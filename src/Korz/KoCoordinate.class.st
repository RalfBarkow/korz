Class {
	#name : #KoCoordinate,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'parent'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoCoordinate class >> named: aSymbol [
	^ self named: aSymbol parent: nil
]

{ #category : #'instance creation' }
KoCoordinate class >> named: aSymbol parent: aCoordinate [
	^ self new
		name: aSymbol;
		parent: aCoordinate;
		yourself
]

{ #category : #comparing }
KoCoordinate >> <= aCoordinate [
	aCoordinate ifNil: [ ^ false ].
	self == aCoordinate ifTrue: [ ^ true ].
	parent ifNil: [ ^ false ].
	^ parent <= aCoordinate
]

{ #category : #accessing }
KoCoordinate >> ancestors [
	| chain current |
	chain := OrderedCollection new.
	current := self.
	[ current notNil ] whileTrue: [
		chain add: current.
		current := current parent
	].
	^ chain
]

{ #category : #comparing }
KoCoordinate >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(anObject isKindOf: KoCoordinate) ifFalse: [ ^ false ].
	^ id = anObject id
]

{ #category : #accessing }
KoCoordinate >> displayName [
	^ name ifNil: [ id asString ]
]

{ #category : #accessing }
KoCoordinate >> hash [
	^ id hash
]

{ #category : #initialization }
KoCoordinate >> initialize [
	super initialize.
	id := UUID new.
	parent := nil.
	name := nil
]

{ #category : #accessing }
KoCoordinate >> name [
	^ name
]

{ #category : #accessing }
KoCoordinate >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #accessing }
KoCoordinate >> parent [
	^ parent
]

{ #category : #accessing }
KoCoordinate >> parent: aCoordinate [
	parent := aCoordinate
]

{ #category : #printing }
KoCoordinate >> printOn: aStream [
	aStream
		nextPutAll: 'KoCoordinate(';
		nextPutAll: self displayName;
		nextPutAll: ')'
]
