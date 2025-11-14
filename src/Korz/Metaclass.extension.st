Extension { #name : #Metaclass }

{ #category : #'*Korz' }
Metaclass >> selector: aSel dimensionConstraints: aDict parameterConstraints: aParamDict [
	"Generic class-side ctor. Works for classes whose instances understand
	 #selector:, #dimensionConstraints:, and #parameterConstraints:."
	^ self new
		selector: aSel;
		dimensionConstraints: (aDict ifNil: [ Dictionary new ]);
		parameterConstraints: (aParamDict ifNil: [ Dictionary new ]);
		yourself
]
