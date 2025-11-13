Class {
	#name : #KoDimension,
	#superclass : #Object,
	#instVars : [
		'name',
		'description'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoDimension class >> named: aSymbol [
	^ self new
		name: aSymbol;
		yourself
]

{ #category : #'instance creation' }
KoDimension class >> named: aSymbol description: aString [
	^ self new
		name: aSymbol;
		description: aString;
		yourself
]

{ #category : #comparing }
KoDimension >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(anObject isKindOf: KoDimension) ifFalse: [ ^ false ].
	^ name = anObject name
]

{ #category : #accessing }
KoDimension >> description [
	^ description
]

{ #category : #accessing }
KoDimension >> description: aString [
	description := aString
]

{ #category : #comparing }
KoDimension >> hash [
	^ name hash
]

{ #category : #accessing }
KoDimension >> name [
	^ name
]

{ #category : #accessing }
KoDimension >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #printing }
KoDimension >> printOn: aStream [
	aStream
		nextPutAll: 'KoDimension(';
		nextPutAll: name asString;
		nextPutAll: ')'
]
