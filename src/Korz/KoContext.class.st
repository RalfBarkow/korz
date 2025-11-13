Class {
	#name : #KoContext,
	#superclass : #Object,
	#instVars : [
		'bindings'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoContext class >> empty [
	^ self new
]

{ #category : #'instance creation' }
KoContext class >> fromDictionary: aDictionary [
	^ self new
		bindings: aDictionary copy;
		yourself
]

{ #category : #'instance creation' }
KoContext class >> withDimension: aDimension coordinate: aCoordinate [
	^ self empty
		at: aDimension put: aCoordinate;
		yourself
]

{ #category : #adding }
KoContext >> at: aDimension put: aCoordinate [
	bindings at: aDimension put: aCoordinate
]

{ #category : #accessing }
KoContext >> at: aDimension [
	^ bindings at: aDimension
]

{ #category : #accessing }
KoContext >> at: aDimension ifAbsent: aBlock [
	^ bindings at: aDimension ifAbsent: aBlock
]

{ #category : #enumerating }
KoContext >> bindingsDo: aBlock [
	bindings keysAndValuesDo: aBlock
]

{ #category : #accessing }
KoContext >> coordinateForDimension: aDimension [
	^ bindings at: aDimension ifAbsent: [ nil ]
]

{ #category : #initialization }
KoContext >> initialize [
	super initialize.
	bindings := IdentityDictionary new
]

{ #category : #accessing }
KoContext >> merge: aDictionary [
	aDictionary keysAndValuesDo: [ :dimension :coordinate |
		self at: dimension put: coordinate
	]
]

{ #category : #copying }
KoContext >> copy [
	^ KoContext fromDictionary: bindings
]

{ #category : #printing }
KoContext >> printOn: aStream [
	aStream nextPutAll: 'KoContext('.
	bindings
		ifEmpty: [ aStream nextPutAll: 'empty' ]
		ifNotEmpty: [
			bindings keysAndValuesDo: [ :dimension :coordinate |
				aStream
					nextPutAll: dimension name asString;
					nextPutAll: '->';
					nextPutAll: coordinate displayName;
					nextPutAll: ' '
			]
		].
	aStream nextPut: $)
]
