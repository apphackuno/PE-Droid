import java.io.*;
import android.widget.EditText;
import android.text.Editable;

public aspect AjcLog{
	static String Path = "data/data";
	static File traceFile = new File(Path, "traceFile.out");

	//Write to File generic Method	
		public static void writeFile (FileWriter fWrt, String complex){
			try {	
				BufferedWriter fos = new BufferedWriter(fWrt);
				fos.write(complex, 0, complex.length());
				fos.newLine();
				fos.close();
			} catch (Exception e) {
				e.printStackTrace();
				}
		}
		
		public static void outWrite(String para, File myFile){
			try {	
			   FileWriter fWrt = new FileWriter(myFile, true);
				writeFile(fWrt, para);
			} catch (Exception e) {
				e.printStackTrace();
				}
		}	

 //Exclude AspectJ Code
	pointcut Test() :
		!within(AjcLog);
		/**  || harmony.java.*..* || org.bouncy*..* || com.low*..* 
				|| com.samsung.android.*..* || android.*..* || org.web*.*..* 
				|| javax.*..* || org.apache.*..* || com.mms*.*..* || org.codehaus.*..* || com.flurry*.*..* 
				|| twitter4j.*..* || gnu.*..* || com.waps.*..* || com.facebook.*..* || com.adwhirl.*..*
				|| com.amazon.*..* || com.actionbarsherlock.*..* || com.wdt.map.*..* || com.appsflyer.*..*
				||com.vungle.*..* || com.tapsense.*..* || com.tremorvideo.*..* || com.google.*..* || com.googlecode.*..* || com.googlecode.mp4parser.*);*/

 
     //---------------------Simulating User Input
     pointcut myInput():
    	 call(* *..*.EditText.setText(..)) && Test();
     
     after(): myInput(){
		String name = thisJoinPoint.getSignature().getName();
		outWrite(name, traceFile);
     }
	Object around(Object tar): myInput() && target(tar){
    	 if (tar instanceof android.widget.EditText ){
    		Editable myText = ((EditText) tar).getText();
    		outWrite("<New Input >{"+myText.toString()+"}", traceFile);
    	 }
    	 return proceed(tar);
     }
     
   }
