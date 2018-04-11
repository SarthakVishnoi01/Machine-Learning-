import java.util.*;
import java.lang.*;
import java.io.*;

// 4 States, 5 possible observations, length of output sequence=21
public class Viterbi
{
	private static int[] States = {0,1,2,3}; // Defines the total number of states
	private static int[] possible_observations = {0,1,2,3,4}; //Number of events possible in each state
	private static int[] observations ={0,1,3,2,4,2,1,0,4,2,3,1,0,2,4,1,1,0,4,3,2}; //Output sequence which we observe
	private static double[] initial_probability ={0.2, 0.3, 0.4, 0.1 }; //Initial Probability Vector
	private static double[][] Transition_probability = { { 0.1, 0.3, 0.3, 0.3,}, {0.2, 0.3, 0.4, 0.1}, {0.5, 0.2, 0.2, 0.1}, {0.1, 0.1, 0.3, 0.5} };//Transition Probability Matrix
	private static double[][] Emission_probability = { { 0.25, 0.15, 0.35, 0.2, 0.05 }, {0.1, 0.3, 0.1, 0.2, 0.3}, {0.4, 0.1, 0.1, 0.2, 0.2}, {0.05, 0.3, 0.2, 0.15, 0.3} }; //Emission Probability Matrix		
	
	Node[][] globe = new Node[States.length][observations.length]; // matrix of Node class for path tracing
	/*
	The Node class contains three things:
	1) The best probability with which we can reach that particular Node.
	2) The state of Node (that is which state it belongs to, helps during Viterbi path backtracing)
	3) The previous node to it. It contains the address of previous node to it which gives the best probability to reach this particular Node.
	*/
	private static class Node 
	{
		public double probability;
		public int state;
		public Node previous=null;   

		public Node(int state,double prob) 
		{
			this.probability = prob;
			this.state=state;
		}
	}
	/*
	max takes in an array of probabilities.
	For each node we calculate the probabilities in reaching it from all the states according to the observation of that Node sequence.
	All these probabilities are stored in the array that is passed to max along with the state of the node for which we are calculating the 
	best probability and the sequence number for it.
	The max function accordingly finds the maximum among all the probabilities and sets the particular element of globe correctly with its 
	probability being the max of the array and its previous set to the index of the array which has the maximum value(this works because the states are from 0 to n).
	*/
	private void max(double[] foo, int m, int current)
	{
		int p=foo.length;
		int marker=0;
		double max=foo[0];
		for(int i=0;i<p;i++)
		{
			if(max<foo[i])
			{
				max=foo[i];
				marker=i;
			}	
		}
		globe[current][m]=new Node(current,max);
		globe[current][m].previous=globe[marker][m-1];		
	}
	
	/*
	This function calculates the probability for each node and assigns it the best probability with help of max function.
	*/
	public void answer(int[] output, int[] states, double[] pi0,double[][] transition, double[][] emission)
	{
		Node start = new Node (10,1.0);
		for(int i=0;i<output.length;i++)
		{
			int observation=output[i];
			if(i==0)
			{
				for(int j=0;j<states.length;j++)
				{
					globe[j][i]=new Node(j,pi0[j]*emission[j][observation]);
					globe[j][i].previous=start;
				}
			}
			else
			{
				for(int j=0;j<states.length;j++)
				{
					double[] temp= new double[4];
					for(int k=0;k<states.length;k++)
					{
						//temp[k]=previous probability*transition probability*emission probability
						temp[k]=globe[k][i-1].probability*transition[k][j]*emission[j][observation];
					}
					max(temp,i,j);
				}
			}
		}
	}
	
	public static void main(String[] args)
	{
		int t= States.length; //Number of states
		int k= observations.length; //Number of events associated with each state
		System.out.println("\n\nTransition probability:");
		for (int i = 0; i < States.length; i++) 
		{
			System.out.print(" " + States[i] + ": {");
			for (int j = 0; j < States.length; j++) 
			{
				System.out.print("  " + States[j] + ": "+ Transition_probability[i][j] + " ");
			}
			System.out.println("}");
		}
		System.out.println("\n\nEmission probability:");
		for (int i = 0; i < States.length; i++) 
		{
			System.out.print(" " + States[i] + ": {");
			for (int j = 0; j < possible_observations.length; j++) 
			{
				System.out.print("  " + possible_observations[j] + ": "+ Emission_probability[i][j] + " ");
			}
			System.out.println("}");
		}
		
		Viterbi v= new Viterbi();
		System.out.println();
		v.answer(observations, States, initial_probability,Transition_probability, Emission_probability);
		int marker=0;
		double max=v.globe[0][k-1].probability;;
		for(int i=0;i<t;i++)
		{
			if(max<v.globe[i][k-1].probability)
			{
				max=v.globe[i][k-1].probability;
				marker=i;
			}

		}
		System.out.println();
		System.out.println("Probability of the whole system is: " + max);
		int[] path=new int[k];
		Node temp=v.globe[marker][k-1];
		path[k-1]=marker;
		for(int i=k-2;i>=0;i--)
		{
			temp=temp.previous;
			path[i]=temp.state;
		}
		System.out.print("Viterbi Path:");
		for(int x=0;x<path.length;x++)
		{
			System.out.print(path[x]+" ");
		}
	}
}
/*
We can modify this code by taking user defined matrices but then in answer function we will also have to pass the globe 2-D array.
*/