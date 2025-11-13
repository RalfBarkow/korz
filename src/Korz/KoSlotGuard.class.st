Class {
	#name : #KoSlotGuard,
	#superclass : #Object,
	#instVars : [
		'dimensionConstraints',
		'selector',
		'parameterConstraints'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoSlotGuard class >> selector: aSymbol [
	^ self selector: aSymbol dimensionConstraints: Dictionary new parameterConstraints: nil
]

{ #category : #'instance creation' }
KoSlotGuard class >> selector: aSymbol dimensionConstraints: aDictionary parameterConstraints: constraints [
	^ self new
		selector: aSymbol;
		dimensionConstraints: aDictionary ifNil: [ Dictionary new ];
		parameterConstraints: constraints;
		yourself
]

{ #category : #accessing }
KoSlotGuard >> coordinateForDimension: aDimension [
	^ dimensionConstraints at: aDimension ifAbsent: [ nil ]
]

{ #category : #accessing }
KoSlotGuard >> dimensionConstraints [
	^ dimensionConstraints
]

{ #category : #accessing }
KoSlotGuard >> dimensionConstraints: aDictionary [
	dimensionConstraints := aDictionary ifNil: [ Dictionary new ]
]

{ #category : #testing }
KoSlotGuard >> hasDimension: aDimension [
	^ dimensionConstraints includesKey: aDimension
]

{ #category : #initialization }
KoSlotGuard >> initialize [
	super initialize.
	dimensionConstraints := Dictionary new.
	selector := #undefined.
	parameterConstraints := nil
]

{ #category : #testing }
KoSlotGuard >> isMoreSpecificThan: anotherGuard [
	(self selector = anotherGuard selector) ifFalse: [ ^ false ].
	(self matchesDimensionConstraintSpecificityOf: anotherGuard) ifFalse: [ ^ false ].
	| dimensionComparison parameterComparison |
	dimensionComparison := self dimensionSpecificityComparedTo: anotherGuard.
	parameterComparison := self parameterSpecificityComparedTo: anotherGuard.
	(dimensionComparison = #equal and: [ parameterComparison = #equal ]) ifTrue: [ ^ false ].
	^ (dimensionComparison = #moreSpecific or: [ dimensionComparison = #equal ])
		and: [ parameterComparison = #moreSpecific or: [ parameterComparison = #equal ] ]
]

{ #category : #testing }
KoSlotGuard >> matchesArguments: arguments [
	parameterConstraints ifNil: [ ^ true ].
	(parameterConstraints size = arguments size) ifFalse: [ ^ false ].
	1 to: parameterConstraints size do: [ :index |
		| constraint argument |
		constraint := parameterConstraints at: index.
		constraint ifNil: [ ^ true ].
		argument := arguments at: index ifAbsent: [ ^ false ].
		(argument respondsTo: #<=) ifFalse: [ ^ false ].
		(argument <= constraint) ifFalse: [ ^ false ].
	].
	^ true
]

{ #category : #testing }
KoSlotGuard >> matchesContext: aContext arguments: arguments [
	^ (self matchesDimensionsInContext: aContext)
		and: [ self matchesArguments: arguments ]
]

{ #category : #private }
KoSlotGuard >> matchesDimensionsInContext: aContext [
	dimensionConstraints keysAndValuesDo: [ :dimension :required |
		| contextCoordinate |
		contextCoordinate := self resolveCoordinateFor: dimension inContext: aContext.
		contextCoordinate ifNil: [ ^ false ].
		(contextCoordinate <= required) ifFalse: [ ^ false ].
	].
	^ true
]

{ #category : #accessing }
KoSlotGuard >> parameterConstraints [
	^ parameterConstraints
]

{ #category : #accessing }
KoSlotGuard >> parameterConstraints: constraints [
	parameterConstraints := constraints
]

{ #category : #private }
KoSlotGuard >> parameterSpecificityComparedTo: anotherGuard [
	parameterConstraints ifNil: [ ^ anotherGuard parameterConstraints ifNil: [ #equal ] ifNotNil: [ #lessSpecific ] ].
	anotherGuard parameterConstraints ifNil: [ ^ #moreSpecific ].
	parameterConstraints size = anotherGuard parameterConstraints size ifFalse: [ ^ #incomparable ].
	| strictlyMoreSpecific |
	strictlyMoreSpecific := false.
	1 to: parameterConstraints size do: [ :index |
		| constraint otherConstraint |
		constraint := parameterConstraints at: index.
		otherConstraint := anotherGuard parameterConstraints at: index.
		otherConstraint ifNil: [
			constraint ifNotNil: [ strictlyMoreSpecific := true ].
		] ifNotNil: [
			constraint ifNil: [ ^ #lessSpecific ].
			(constraint <= otherConstraint) ifFalse: [ ^ #incomparable ].
			(constraint = otherConstraint) ifFalse: [ strictlyMoreSpecific := true ].
		].
	].
	^ strictlyMoreSpecific
		ifTrue: [ #moreSpecific ]
		ifFalse: [ #equal ]
]

{ #category : #printing }
KoSlotGuard >> printOn: aStream [
	aStream
		nextPutAll: 'KoSlotGuard(';
		nextPutAll: selector asString;
		nextPutAll: ')'
]

{ #category : #accessing }
KoSlotGuard >> selector [
	^ selector
]

{ #category : #accessing }
KoSlotGuard >> selector: aSymbol [
	selector := aSymbol asSymbol
]

{ #category : #private }
KoSlotGuard >> dimensionSpecificityComparedTo: anotherGuard [
	| strictlyMoreSpecific |
	strictlyMoreSpecific := false.
	dimensionConstraints keysAndValuesDo: [ :dimension :coordinate |
		| otherCoord |
		otherCoord := anotherGuard coordinateForDimension: dimension.
		otherCoord
			ifNil: [ strictlyMoreSpecific := true ]
			ifNotNil: [
				(coordinate <= otherCoord) ifFalse: [ ^ #incomparable ].
				(coordinate = otherCoord) ifFalse: [ strictlyMoreSpecific := true ].
			]
	].
	anotherGuard dimensionConstraints keysDo: [ :dimension |
		(self hasDimension: dimension) ifFalse: [ ^ #lessSpecific ].
	].
	^ strictlyMoreSpecific
		ifTrue: [ #moreSpecific ]
		ifFalse: [ #equal ]
]

{ #category : #private }
KoSlotGuard >> matchesDimensionConstraintSpecificityOf: anotherGuard [
	^ self selector = anotherGuard selector
]

{ #category : #private }
KoSlotGuard >> resolveCoordinateFor: aDimension inContext: aContext [
	(aContext respondsTo: #coordinateForDimension:)
		ifTrue: [ ^ aContext coordinateForDimension: aDimension ].
	(aContext respondsTo: #at:ifAbsent:)
		ifTrue: [ ^ aContext at: aDimension ifAbsent: [ nil ] ].
	^ nil
]
