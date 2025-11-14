Class {
	#name : #KoSlotSpace,
	#superclass : #Object,
	#category : #'Korz-Projection'
}

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addCoordinateNamed: aSymbol onDimension: aDim parent: aParent [
	| st byDim coord |
	st := self kozState.
	byDim := (st at: #coordinates) at: aDim ifAbsentPut: [ Dictionary new ].
	coord := byDim
			at: aSymbol
			ifAbsentPut: [ Dictionary
					newFrom: {#name -> aSymbol.
							#dimension -> aDim.
							#parent -> aParent} ].
	^ coord
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addDimensionNamed: aSymbol [
	| st dims |
	st := self kozState.
	dims := st at: #dimensions.
	(dims includes: aSymbol) ifFalse: [ dims add: aSymbol ].
	^ aSymbol
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addSlot: aSlot [
	(self kozState at: #slots) add: aSlot.
	^ aSlot
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addSlotSelector: aSelector dimensionConstraints: aDict parameterConstraints: aParam implementation: aBlock [
	| slot |
	slot := KoSlot
			selector: aSelector
			dimensionConstraints: aDict
			parameterConstraints: aParam
			implementation: aBlock.
	self addSlot: slot.
	^ slot
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addSlotSelector: aSelector implementation: aBlock [
	^ self
		addSlotSelector: aSelector
		dimensionConstraints: Dictionary new
		parameterConstraints: nil
		implementation: aBlock
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> kozState [
	^ (Smalltalk at: #KoSlotSpaceState)
		at: self
		ifAbsentPut: [ Dictionary new
				at: #dimensions put: OrderedCollection new;
				at: #coordinates put: Dictionary new;
				at: #slots put: OrderedCollection new;
				yourself	"dim -> (name -> coord)" ]
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> matchingSlotsForContext: aContext selector: aSelector arguments: ignored [
	"Return the slots whose guard selector matches and whose dimension constraints
	 are exactly satisfied by aContext (identity compare on coords)."

	| slots |
	slots := self kozState at: #slots.
	^ slots select: [ :slot |
		| guard constraints matches |
		guard := (slot respondsTo: #guard)
			ifTrue: [ slot guard ]
			ifFalse: [ nil ].
		guard isNil
			ifTrue: [ false ]
			ifFalse: [
				guard selector = aSelector
					ifFalse: [ false ]
					ifTrue: [
						constraints := guard dimensionConstraints.
						constraints isNil
							ifTrue: [ true ]
							ifFalse: [
								matches := true.
								constraints keysAndValuesDo: [ :dim :coord |
									((aContext at: dim ifAbsent: [ nil ]) == coord)
										ifFalse: [ matches := false ] ].
								matches ] ] ] ]
]
