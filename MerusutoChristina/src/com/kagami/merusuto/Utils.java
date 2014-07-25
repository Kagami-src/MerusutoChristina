package com.kagami.merusuto;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.json.JSONObject;

import android.content.Context;

public class Utils {
	static public JSONObject readData(Context context){
		try {
			InputStreamReader isr=new InputStreamReader(context.getResources().getAssets().open("data/list.json"));
			BufferedReader br=new BufferedReader(isr);
			String s="";
			String line="";
			while(line!=null){
				s=s+line;
				line=br.readLine();
			}
			br.close();
			return new JSONObject(s);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

}
