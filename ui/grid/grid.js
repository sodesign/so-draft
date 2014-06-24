jQuery(function($){
	var $rows = $(".test > .row")
	$rows.width($rows[0].scrollWidth);
	$rows.each(function(){
		this.children.item(0).innerHTML = this.scrollWidth + "x" + this.scrollHeight;
		console.debug("0:" + this.clientWidth + "," + this.scrollWidth);
		//this.style.width  = this.scrollWidth + "px";
		//console.debug("1:" + this.clientWidth + "," + this.scrollWidth);
	})
});

function gridCtrl($scope) {
	$scope.columnSize = 2;
	$scope.rows = [["11", "12"],["21", "22"]];

	$scope.addRow = function() {
		var row = [];
		for (var i = 1; i <= $scope.columnSize; i++) {
			row.push(($scope.rows.length + 1) + "" + i);
		};
		$scope.rows.push(row);
	}

	$scope.deleteRow = function() {
		$scope.rows.pop();
	}

	$scope.addColumn = function() {
		$scope.columnSize++;
		for (var i = 0; i < $scope.rows.length; i++) {
			$scope.rows[i].push(i + 1 + "" + $scope.columnSize);
		};
	}

	$scope.deleteColumn = function() {
		if($scope.columnSize == 0) return;
		$scope.columnSize--;
		for (var i = 0; i < $scope.rows.length; i++) {
			$scope.rows[i].pop();
		};
	}
}