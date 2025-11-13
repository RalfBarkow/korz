Class {
	#name : #KoDispatcherTest,
	#superclass : #TestCase,
	#category : #'Korz-Tests'
}

{ #category : #tests }
KoDispatcherTest >> testDispatchRaisesWhenAmbiguous [
	| slotSpace rcvr coord child context |
	slotSpace := KoSlotSpace new.
	rcvr := slotSpace addDimensionNamed: #rcvr.
	coord := slotSpace addCoordinateNamed: #parent onDimension: rcvr parent: nil.
	child := slotSpace addCoordinateNamed: #child onDimension: rcvr parent: coord.
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #draw
			dimensionConstraints: (Dictionary newFrom: { rcvr -> coord })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'one' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #draw
			dimensionConstraints: (Dictionary newFrom: { rcvr -> coord })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'two' ]).
	context := Dictionary newFrom: { rcvr -> coord }.
	self
		should: [ KoDispatcher dispatchSelector: #draw arguments: #() inContext: context onSlotSpace: slotSpace ]
		raise: KoAmbiguousDispatch
]

{ #category : #tests }
KoDispatcherTest >> testDispatchEvaluatesMostSpecific [
	| slotSpace rcvr parent child context result |
	slotSpace := KoSlotSpace new.
	rcvr := slotSpace addDimensionNamed: #rcvr.
	parent := slotSpace addCoordinateNamed: #parent onDimension: rcvr parent: nil.
	child := slotSpace addCoordinateNamed: #child onDimension: rcvr parent: parent.
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #draw
			dimensionConstraints: (Dictionary newFrom: { rcvr -> parent })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'general' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #draw
			dimensionConstraints: (Dictionary newFrom: { rcvr -> child })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'specific' ]).
	context := Dictionary newFrom: { rcvr -> child }.
	result := KoDispatcher
		dispatchSelector: #draw
		arguments: #()
		inContext: context
		onSlotSpace: slotSpace.
	self assert: result equals: 'specific'
]

{ #category : #tests }
KoDispatcherTest >> testMessageNotUnderstoodRaisedWhenNoMatch [
	| slotSpace |
	slotSpace := KoSlotSpace new.
	self
		should: [ KoDispatcher dispatchSelector: #unknown arguments: #() inContext: KoContext empty onSlotSpace: slotSpace ]
		raise: KoMessageNotUnderstood
]
