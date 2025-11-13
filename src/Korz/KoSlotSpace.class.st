Class {
	#name : #KoSlotSpace,
	#superclass : #Object,
	#instVars : [
		'dimensions',
		'coordinates',
		'slots',
		'coordinateDimensions'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #adding }
KoSlotSpace >> addDimensionNamed: aSymbol [
	^ self addDimensionNamed: aSymbol description: nil
]

{ #category : #adding }
KoSlotSpace >> addDimensionNamed: aSymbol description: aString [
	| dimension |
	dimension := KoDimension named: aSymbol description: aString.
	dimensions add: dimension.
	^ dimension
]

{ #category : #adding }
KoSlotSpace >> addCoordinateNamed: aSymbol onDimension: aDimension parent: parentCoordinate [
	| coordinate |
	self assertDimensionKnown: aDimension.
	parentCoordinate ifNotNil: [
		(self dimensionForCoordinate: parentCoordinate) = aDimension
			ifFalse: [ self error: 'Parent coordinate must belong to same dimension' ] ].
	coordinate := KoCoordinate named: aSymbol parent: parentCoordinate.
	coordinates add: coordinate.
	coordinateDimensions at: coordinate put: aDimension.
	^ coordinate
]

{ #category : #adding }
KoSlotSpace >> addSlot: aSlot [
	slots add: aSlot.
	^ aSlot
]

{ #category : #dispatching }
KoSlotSpace >> bestSlotsForContext: aContext selector: aSelector arguments: arguments [
	| matches |
	matches := self matchingSlotsForContext: aContext selector: aSelector arguments: arguments.
	^ self removeLessSpecificSlots: matches
]

{ #category : #private }
KoSlotSpace >> removeLessSpecificSlots: slotCollection [
	^ slotCollection select: [ :slot |
		slotCollection noneSatisfy: [ :other |
			other == slot
				ifTrue: [ false ]
				ifFalse: [ other guard isMoreSpecificThan: slot guard ] ] ]
]

{ #category : #accessing }
KoSlotSpace >> coordinates [
	^ coordinates
]

{ #category : #accessing }
KoSlotSpace >> dimensionForCoordinate: aCoordinate [
	^ coordinateDimensions at: aCoordinate ifAbsent: [ nil ]
]

{ #category : #accessing }
KoSlotSpace >> dimensions [
	^ dimensions
]

{ #category : #private }
KoSlotSpace >> assertDimensionKnown: aDimension [
	(dimensions includes: aDimension) ifFalse: [
		self error: 'Unknown dimension'
	]
]

{ #category : #initialization }
KoSlotSpace >> initialize [
	super initialize.
	dimensions := OrderedCollection new.
	coordinates := OrderedCollection new.
	coordinateDimensions := IdentityDictionary new.
	slots := OrderedCollection new
]

{ #category : #matching }
KoSlotSpace >> matchingSlotsForContext: aContext selector: aSelector arguments: arguments [
	^ slots select: [ :slot |
		slot guard selector = aSelector
			and: [ slot matchesContext: aContext arguments: arguments ]
	]
]

{ #category : #printing }
KoSlotSpace >> printOn: aStream [
	aStream
		nextPutAll: 'KoSlotSpace(';
		nextPutAll: dimensions size asString;
		nextPutAll: ' dimensions, ';
		nextPutAll: slots size asString;
		nextPutAll: ' slots)'
]

{ #category : #accessing }
KoSlotSpace >> slots [
	^ slots
]
