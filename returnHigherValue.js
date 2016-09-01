exampleData = [
	{
		name: "Asian",
		value: 1000
	},
	{
		name: "Black",
		value: 2000
	},
	{
		name: "Hispanic",
		value: 30000
	},
	{
		name: "Other",
		value: 4000
	},
	{
		name: "White",
		value: 5000
	}
]

function returnHigherValue (array){
	var highest = {
		name: "none",
		value: 0
	}

	array.forEach(function(d){
		if(d.value > highest.value){
			highest = d
		}
	})

	return highest
}

console.log(returnHigherValue(exampleData))