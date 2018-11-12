$TestObject= [PSCustomObject]@{
String="test"
Int = 23
Double=23.1
Bool=$true
}

$TestObjectB= [PSCustomObject]@{
String=[string]
Int = [int]
Double=[double]
Bool=[bool]
datetime=[datetime]
}


function Get-PSObjectParamTypes(){
param(
    $Object
)
    $NoteProperties =$object | get-member -MemberType NoteProperty
   foreach($property in $NoteProperties)
   {
   $Pdefinition = $property.Definition.split(" ")
   $PType = $Pdefinition[0]
       if($PType -eq "RuntimeType"){
            $PType=$Pdefinition[1].split("=")[0]
        }

   Add-Member -InputObject $property -MemberType NoteProperty -name "Type" -Value $PType
   }

    return $NoteProperties
}

