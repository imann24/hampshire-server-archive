import java.util.*;

public class QuickSort {
	
	boolean debug = false;
	static int defaultListSize = 10;

	public static void main(String [ ] args) {
		QuickSort sorter = new QuickSort();
		
		System.out.println("Test Array:");
		int[] testNumbers = sorter.randomNumbers(
			args.length > 0 ? Integer.parseInt(args[0]) : defaultListSize, 
			0, 
			100);

		sorter.debugArray(testNumbers);

		System.out.println("");
		System.out.println("Quicksorted Test Array:");
		sorter.debugArray(sorter.sort(testNumbers, 0, testNumbers.length - 1));


	}

	int[] sort (int[] unsortedListOfNumbers, int startIndex, int endIndex) {
		
		if (startIndex < endIndex) {
			int partitionIndex = partition(unsortedListOfNumbers, startIndex, endIndex);
			sort(unsortedListOfNumbers, startIndex, partitionIndex-1);
			sort(unsortedListOfNumbers, partitionIndex + 1, endIndex);
		}

		return unsortedListOfNumbers;
	}

	int partition(int[] unpartitionedListOfNumbers, int startIndex, int endIndex) {
		
		int partitionValue = unpartitionedListOfNumbers[endIndex];
		
		int partitionValueInsertIndex = startIndex - 1;

		for (int j = startIndex; j < endIndex; j++) {

			if (unpartitionedListOfNumbers[j] <= partitionValue) {
				partitionValueInsertIndex++;
				swap(unpartitionedListOfNumbers, partitionValueInsertIndex, j);
			}

		}
		
		if (partitionValue < unpartitionedListOfNumbers[partitionValueInsertIndex + 1]) {
			swap(unpartitionedListOfNumbers, partitionValueInsertIndex+1, endIndex);
		}	

		if (debug) {
			System.out.println("The partitioned value is " + partitionValue + " at position " + partitionValueInsertIndex + 1);
		}

		return partitionValueInsertIndex + 1;
	}

	void swap (int[] targetArray, int index1, int index2) {
		
		if (debug) {
			System.out.println("Swapping " + targetArray[index1] + " and " + targetArray[index2]);
		}


		int tempValue = targetArray[index1];
		targetArray[index1] = targetArray[index2];
		targetArray[index2] = tempValue;
	}

	void debugArray (int[] arrayToPrint) {
		System.out.print("[");
		for (int i = 0; i < arrayToPrint.length - 1; i++) {
			System.out.print(arrayToPrint[i] + ", ");
		}

		System.out.println(arrayToPrint[arrayToPrint.length-1] + "]");

	}

	//http://stackoverflow.com/questions/363681/generating-random-integers-in-a-specific-range
	int [] randomNumbers (int length, int min, int max) {
		int[] randomNumbersArray = new int[length];

		Random random = new Random();

		for (int i = 0; i < randomNumbersArray.length; i++) {
			randomNumbersArray[i] = min + random.nextInt(max - min + 1);
		}

		return randomNumbersArray;
	}
}