Class {
	#name : #KoSlotSpace,
	#superclass : #Object,
	#category : #'Korz-Projection'
}

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addCoordinateNamed: coordName onDimension: aDimension parent: aParentOrNil [
	"Create a simple coordinate object as a dictionary.
	We keep it deliberately tiny and structural."
	| st coords byDim coord |
	st := self kozState.
	coords := st at: #coordinates.
	byDim := coords at: aDimension ifAbsentPut: [ Dictionary new ].
	coord := Dictionary newFrom: {
		#dimension -> aDimension.
		#name      -> coordName.
		#parent    -> aParentOrNil }.
	byDim at: coordName put: coord.
	^ coord
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> addDimensionNamed: aSymbol [
	"Create / record a dimension identified by aSymbol.
	For now the dimension *is* the symbol."
	| st dims |
	st := self kozState.
	dims := st at: #dimensions.
	dims at: aSymbol put: aSymbol.
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
	"Return (and lazily create) the per-instance state dictionary.
	Keys we use:
	  #dimensions  -> Dictionary (name -> dimension object)
	  #coordinates -> Dictionary (dimension -> (name -> coord))
	  #slots       -> OrderedCollection of KoSlot"
	^ (KoSlotSpaceState at: self ifAbsentPut: [
		Dictionary newFrom: {
			#dimensions  -> Dictionary new.
			#coordinates -> Dictionary new.
			#slots       -> OrderedCollection new } ])
]

{ #category : #'Korz-Projection-Compat' }
KoSlotSpace >> matchingSlotsForContext: aContext selector: aSelector arguments: ignored [
	"Return the slots whose guard selector matches and whose
	dimension constraints are satisfied by aContext.
	We compare coordinates by identity (==) and also by value (=)."

	| slots result |
	slots := self kozState at: #slots.
	result := OrderedCollection new.

	slots do: [ :slot |
		| guard ok constraints |
		guard := (slot respondsTo: #guard)
			ifTrue: [ slot guard ]
			ifFalse: [ nil ].
		guard isNil ifFalse: [
			(guard selector = aSelector) ifTrue: [
				constraints := guard dimensionConstraints.
				constraints isNil
					ifTrue: [ result add: slot ]
					ifFalse: [
						ok := true.
						constraints keysAndValuesDo: [ :dim :coord |
							| ctxCoord |
							ctxCoord := aContext at: dim ifAbsent: [ nil ].
							((ctxCoord == coord) or: [ ctxCoord = coord ])
								ifFalse: [ ok := false ] ].
						ok ifTrue: [ result add: slot ] ] ] ] ].
	^ result
]
