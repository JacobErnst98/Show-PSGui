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

function Show-Psgui () {
	param(
		$object,
		[int]$height = 600,
		[int]$width = 600
	)
	$Form = New-Object system.Windows.Forms.Form
	#TODO automate width and height
	$Form.ClientSize = '$width,$height'
	$Form.text = "Form"
	$Form.TopMost = $false

	$NoteProperties = Get-PSObjectParamTypes $object
	$currentX = 15
	$currentY = 15
	$fields = @()
	$fieldCount = 0
	foreach ($NP in $NoteProperties)
	{
		switch ($NP.Type)
		{
			bool
			{
				New-Variable -Name "Checkbox_$($np.Name)" -Value (New-Object system.Windows.Forms.CheckBox)
				(Get-Variable -Name "Checkbox_$($np.Name)")
				(Get-Variable -Name "Checkbox_$($np.Name)").text = "checkBox"
				(Get-Variable -Name "Checkbox_$($np.Name)").AutoSize = $false
				(Get-Variable -Name "Checkbox_$($np.Name)").width = 95
				(Get-Variable -Name "Checkbox_$($np.Name)").height = 20
				(Get-Variable -Name "Checkbox_$($np.Name)").location = New-Object System.Drawing.Point ($currentX,$currentY)
				(Get-Variable -Name "Checkbox_$($np.Name)").Font = 'Microsoft Sans Serif,10'
			}



		}
		$currentX += 25

	}


}
