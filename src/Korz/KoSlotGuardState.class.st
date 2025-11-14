Class {
	#name : #KoSlotGuardState,
	#superclass : #Object,
	#classVars : [
		'Registry'
	],
	#category : #'Korz-Projection-Compat'
}

{ #category : #delegating }
KoSlotGuardState class >> at: key ifAbsent: aBlock [
	^ self default at: key ifAbsent: aBlock
]

{ #category : #delegating }
KoSlotGuardState class >> at: key ifAbsentPut: aBlock [
	^ self default at: key ifAbsentPut: aBlock
]

{ #category : #delegating }
KoSlotGuardState class >> at: key put: value [
	^ self default at: key put: value
]

{ #category : #mutating }
KoSlotGuardState class >> clear [
	"Drop all entries."

	Registry := nil
]

{ #category : #accessing }
KoSlotGuardState class >> default [
	"Singleton WeakKeyDictionary registry."

	^ Registry ifNil: [ Registry := WeakKeyDictionary new ]
]

{ #category : #delegating }
KoSlotGuardState class >> keys [
	^ self default keys
]

{ #category : #delegating }
KoSlotGuardState class >> removeKey: key [
	^ self default removeKey: key ifAbsent: [ nil ]
]

{ #category : #delegating }
KoSlotGuardState class >> size [
	^ self default size
]
