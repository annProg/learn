package com.hnubbs.ip;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;

public class HnubbsIP extends Configured implements Tool {
	public static class Map extends Mapper<LongWritable, Text, Text, IntWritable> {
		private final static IntWritable one = new IntWritable(1);
		private Text ipaddr = new Text();
		
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
			String line = value.toString();
			String [] item = line.split("\\.");
			ipaddr.set(item[0] + "." + item[1] + "." + item[2] + ".0");
			context.write(ipaddr,one);
		}
	}
	
	public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {
		public void reduce (Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
			int sum=0;
			for(IntWritable val : values) {
				sum += val.get();
			}
			context.write(key, new IntWritable(sum));
		}
	}
	
	public static class SortMapper extends Mapper<Object, Text, IntWritable,Text>{
	    
	    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
	      
	    	IntWritable times = new IntWritable(1);
	 	    Text ipaddr = new Text();
	 	   
	 	    
	    	String eachline=value.toString();
	    	String[] eachterm =eachline.split("	");
	    	
	    	if(eachterm.length==2){
	    		ipaddr.set(eachterm[0]);
	    		times.set(Integer.parseInt(eachterm[1]));
	    		context.write(times,ipaddr);
	    	}else{
	    		ipaddr.set("error");
	    		context.write(times,ipaddr);
	    	}
	    }
	} 
	
	
	public static class SortReducer extends Reducer<IntWritable,Text,IntWritable,Text> {
		private Text ipaddr = new Text();

		public void reduce(IntWritable key,Iterable<Text> values, Context context) throws IOException, InterruptedException {

			//不同的ip段可能出现相同的次数
			for (Text val : values) {
				ipaddr.set(val);
				context.write(key,ipaddr);
			}
		}
	}
	
	private static class IntDecreasingComparator extends IntWritable.Comparator {
		public int compare(WritableComparable a, WritableComparable b) {
			return -super.compare(a, b);
		}

		public int compare(byte[] b1, int s1, int l1, byte[] b2, int s2, int l2) {
		 	return -super.compare(b1, s1, l1, b2, s2, l2);
		}
	}
	
	public int run(String[] args) throws Exception {
		Configuration conf = new Configuration();
		Job job = new Job(getConf());
		job.setJarByClass(HnubbsIP.class);
		job.setJobName("ipaddrcount");
		
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		
		job.setMapperClass(Map.class);
		job.setReducerClass(Reduce.class);
		
		job.setInputFormatClass(TextInputFormat.class);
		job.setOutputFormatClass(TextOutputFormat.class);
		
		//定义一个临时目录，先将词频统计任务的输出结果写到临时目录中, 下一个排序任务以临时目录为输入目录。
		//FileInputFormat.setInputPaths(job, new Path(args[0]));
		FileInputFormat.addInputPath(job, new Path(args[0]));
		Path tempDir = new Path("csdn-temp-" + Integer.toString(new Random().nextInt(Integer.MAX_VALUE))); 
		FileOutputFormat.setOutputPath(job, tempDir);
		
	    
		if(job.waitForCompletion(true))
		{
			Job sortJob = new Job(conf,"ipsort");
			sortJob.setJarByClass(HnubbsIP.class);

			FileInputFormat.addInputPath(sortJob, tempDir);

			sortJob.setMapperClass(SortMapper.class);
			FileOutputFormat.setOutputPath(sortJob, new Path(args[1]));

			sortJob.setOutputKeyClass(IntWritable.class);
			sortJob.setOutputValueClass(Text.class);

			sortJob.setSortComparatorClass(IntDecreasingComparator.class);

			FileSystem.get(conf).deleteOnExit(tempDir);

			System.exit(sortJob.waitForCompletion(true) ? 0 : 1);
		}
				
		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
		
	}
	
	public static void main(String[] args) throws Exception {
		int ret = ToolRunner.run(new HnubbsIP(),args);
		System.exit(ret);
	}
}