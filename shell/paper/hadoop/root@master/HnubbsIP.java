package com.hnubbs.ip;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.fs.Path;
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
			String [] item = line.split("-");
			ipaddr.set(item[1]);
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
	
	public int run(String[] args) throws Exception {
		Job job = new Job(getConf());
		job.setJarByClass(ipaddrCount.class);
		job.setJobName("ipaddrcount");
		
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		
		job.setMapperClass(Map.class);
		job.setReducerClass(Reduce.class);
		
		job.setInputFormatClass(TextInputFormat.class);
		job.setOutputFormatClass(TextOutputFormat.class);
		
		FileInputFormat.setInputPaths(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		
		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
		
	}
	
	public static void main(String[] args) throws Exception {
		int ret = ToolRunner.run(new ipaddrCount(),args);
		System.exit(ret);
	}
}