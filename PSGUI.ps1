$TestObject = [pscustomobject]@{
	String = "test"
	multi = "test `n multiline"
	Stringb = "test"
	Stringc = "test"
	multib = "test `n multiline"
	multic = "test `n multiline"
	multid = "test `n multiline"
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
	$Form.ClientSize = "$width,$height"
	$Form.text = "Form"
	$Form.TopMost = $false

	$NoteProperties = Get-PSObjectParamTypes $object
	$currentX = 15
	$currentY = 15
	$maxFieldWidths = 0
	$fields = @()
	$fieldCount = 0

	foreach ($NP in $NoteProperties)
	{
		switch ($NP.Type)
		{
			bool
			{
				New-Variable -Name "Checkbox_$($np.Name)" -Value (New-Object system.Windows.Forms.CheckBox)
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.text = "$($np.Name)"
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.AutoSize = $false
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.location = New-Object System.Drawing.Point ($currentX,$currentY)
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.Font = 'Microsoft Sans Serif,10'

				#size field
				$FontSize = Get-StringSize -control ((Get-Variable -Name "Checkbox_$($np.Name)").Value)
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.width = [math]::Ceiling($FontSize.width)
				(Get-Variable -Name "Checkbox_$($np.Name)").Value.height = [math]::Ceiling($FontSize.height)

				#add field to form
				$Form.controls.Add($((Get-Variable -Name "Checkbox_$($np.Name)").Value))
				$currentY = ((Get-Variable -Name "Checkbox_$($np.Name)").Value.height + (Get-Variable -Name "Checkbox_$($np.Name)").Value.location.y) + 5
				if ($maxFieldWidths -lt ((Get-Variable -Name "Checkbox_$($np.Name)").Value.width + (Get-Variable -Name "Checkbox_$($np.Name)").Value.location.x)) {
					$maxFieldWidths = ((Get-Variable -Name "Checkbox_$($np.Name)").Value.width + (Get-Variable -Name "Checkbox_$($np.Name)").Value.location.x) + 15
				}
			}
			string
			{
				#Create Label field for the string input
				New-Variable -Name "Label_$($np.Name)" -Value (New-Object system.Windows.Forms.Label)
				(Get-Variable -Name "Label_$($np.Name)").Value.text = "$($np.Name)"
				(Get-Variable -Name "Label_$($np.Name)").Value.AutoSize = $false
				(Get-Variable -Name "Label_$($np.Name)").Value.location = New-Object System.Drawing.Point ($currentX,$currentY)
				(Get-Variable -Name "Label_$($np.Name)").Value.Font = 'Microsoft Sans Serif,10'

				#size field
				$FontSize = Get-StringSize -control ((Get-Variable -Name "Label_$($np.Name)").Value)
				(Get-Variable -Name "Label_$($np.Name)").Value.width = [math]::Ceiling($FontSize.width)
				(Get-Variable -Name "Label_$($np.Name)").Value.height = [math]::Ceiling($FontSize.height)
				#add field to form
				$Form.controls.Add($((Get-Variable -Name "Label_$($np.Name)").Value))



				#Get Position of textbox after label
				$tmpX = $currentX + (Get-Variable -Name "Label_$($np.Name)").Value.width + 5

				#create Textbox element
				New-Variable -Name "TextBox_$($np.Name)" -Value (New-Object system.Windows.Forms.TextBox)
				(Get-Variable -Name "TextBox_$($np.Name)").Value.location = New-Object System.Drawing.Point ($tmpX,$currentY)
				(Get-Variable -Name "TextBox_$($np.Name)").Value.Font = 'Microsoft Sans Serif,10'


				#check if input should be multiline              
				if ($object. "$($np.Name)".GetType().Name -eq "string") {
					if ($object. "$($np.Name)".Contains("`n")) {
						(Get-Variable -Name "TextBox_$($np.Name)").Value.multiline = $true
						(Get-Variable -Name "TextBox_$($np.Name)").Value.Scrollbars = "Vertical"
						(Get-Variable -Name "TextBox_$($np.Name)").Value.text = $object. "$($np.Name)"
					}
					(Get-Variable -Name "TextBox_$($np.Name)").Value.text = $object. "$($np.Name)"
				}

				#resize textbox
				$FontSize = Get-StringSize -control ((Get-Variable -Name "TextBox_$($np.Name)").Value)
				if ($FontSize.width -lt 200)
				{
					(Get-Variable -Name "TextBox_$($np.Name)").Value.width = 200
				}
				else {
					(Get-Variable -Name "TextBox_$($np.Name)").Value.width = [math]::Ceiling($FontSize.width) + 10
				}
				if ($FontSize.height -lt 20)
				{
					(Get-Variable -Name "TextBox_$($np.Name)").Value.height = 20
				}
				else {
					(Get-Variable -Name "TextBox_$($np.Name)").Value.height = [math]::Ceiling($FontSize.height) + 3 + ([math]::Ceiling($FontSize.height / 2))
				}

				#add textbox to form
				$Form.controls.Add($((Get-Variable -Name "TextBox_$($np.Name)").Value))


				if ($maxFieldWidths -lt ((Get-Variable -Name "TextBox_$($np.Name)").Value.width + (Get-Variable -Name "TextBox_$($np.Name)").Value.location.x)) {
					$maxFieldWidths = ((Get-Variable -Name "TextBox_$($np.Name)").Value.width + (Get-Variable -Name "TextBox_$($np.Name)").Value.location.x) + 15
				}
				$currentY = ((Get-Variable -Name "TextBox_$($np.Name)").Value.height + (Get-Variable -Name "TextBox_$($np.Name)").Value.location.y) + 5


			}



		}

		Write-Host "$($np.Name) $currentY"

	}
	$Form.width = $maxFieldWidths + 15
	Write-Host $currentY
	$Form.height = $currentY
	[void]$Form.ShowDialog()
}



function Get-StringSize () {
	param(
		$control
	)
	Add-Type -Assembly System.Drawing
	$BlankImage = New-Object System.Drawing.Bitmap (500,500)
	$gr = [System.Drawing.Graphics]::FromImage($BlankImage)
	return $gr.MeasureString("$($control.text)",$($control.Font))
}
