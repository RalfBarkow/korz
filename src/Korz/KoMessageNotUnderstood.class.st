Class {
	#name : #KoMessageNotUnderstood,
	#superclass : #Error,
	#instVars : [
		'selector',
		'context'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoMessageNotUnderstood class >> signalSelector: aSelector context: aContext [
	self new
		selector: aSelector;
		context: aContext;
		signal
]

{ #category : #accessing }
KoMessageNotUnderstood >> context [
	^ context
]

{ #category : #accessing }
KoMessageNotUnderstood >> context: aContext [
	context := aContext
]

{ #category : #accessing }
KoMessageNotUnderstood >> messageText [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'No slot matched selector ';
			nextPutAll: selector asString;
			nextPutAll: ' for context ';
			print: context ]
]

{ #category : #accessing }
KoMessageNotUnderstood >> selector [
	^ selector
]

{ #category : #accessing }
KoMessageNotUnderstood >> selector: aSelector [
	selector := aSelector
]
