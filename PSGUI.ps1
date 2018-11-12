$TestObject = [pscustomobject]@{
	String = "test"
	Int = 23
	Double = 23.1
	Bool = $true
}



$TestObjectB = [pscustomobject]@{
	String = [string]
	Int = [int]
	Double = [double]
	Bool = [bool]
	datetime = [datetime]
}
#This is a test

function Get-PSObjectParamTypes () {
	param(
		$Object
	)
	$NoteProperties = $object | Get-Member -MemberType NoteProperty
	foreach ($property in $NoteProperties)
	{
		$Pdefinition = $property.Definition.split(" ")
		$PType = $Pdefinition[0]
		if ($PType -eq "RuntimeType") {
			$PType = $Pdefinition[1].split("=")[0]
		}

		Add-Member -InputObject $property -MemberType NoteProperty -Name "Type" -Value $PType
	}

	return $NoteProperties
}

