package com.kagami.merusuto;

import org.json.JSONObject;

public class UnitItem {
	public String name1;
	public String name2;
	public int id;
	public int element;
	public int atk;
	public int life;
	public int speed;
	public float quick;
	public int tough;
	public int rare;
	
	//1:"斩击";2:"突击";3"打击"; 4:"弓箭"; 5:"魔法";6:"铳弹"; 7:"回复";
	public int weapon;
	public int reach;
	public int num;
	public int type;//1早熟 2平均 3晚成

	public float fire;
	public float aqua;
	public float wind;
	public float light;
	public float dark;
	
	public UnitItem(int id,JSONObject json){
		this.id=id;
		this.name1=json.optString("name1","");
	    this.name2=json.optString("name2","");
	    this.element=json.optInt("element",0);
	    this.life=json.optInt("life",0);
	    this.atk=json.optInt("atk",0);
	    this.speed=json.optInt("speed",0);
	    this.quick=(float)json.optDouble("quick",0);
	    this.tough=json.optInt("tough",0);
	    this.rare=json.optInt("rare",0);
	    this.weapon=json.optInt("weapon",0);
	    this.reach=json.optInt("reach",0);
	    this.type=json.optInt("type",0);
	    this.num=json.optInt("num",0);
	    
	    this.fire=(float)json.optDouble("fire",0);
	    this.aqua=(float)json.optDouble("aqua",0);
	    this.wind=(float)json.optDouble("wind",0);
	    this.light=(float)json.optDouble("light",0);
	    this.dark=(float)json.optDouble("dark",0);
	}
	
	public String getRareString(){
		String ret="";
		for(int i=0;i<rare;i++)
			ret+="★";
		return ret;
	}
	public String getTypeString(){
		String text="";
		switch (type) {
        case 1:
            text="早熟";
            break;
        case 2:
            text="平均";
            break;
        case 3:
            text="晚成";
            break;
        default:
            break;
    }
		return "成长:"+text;
	}
	
	public int getMaxLvDPS(){
		return (int)(getMaxLvAtk()/5.0f/quick);
	}
	public int getMaxDPS(){
		//+（HP&ATK*早熟0.9/（20+星级*10））*75
		return (int)(getMaxAtk()/5.0f/quick);
	}
	
	public int getMaxAtk(){
		float f=0;
		switch (type) {
        case 1:
            f=1.9f;
            break;
        case 2:
        	f=2.0f;
            break;
        case 3:
        	f=2.1f;
            break;
        default:
            break;
		}
		return (int)(atk*f+atk*(f-1)/(20+10*rare)*75);
	}
	public int getMaxLvAtk(){
		float f=0;
		switch (type) {
        case 1:
            f=1.9f;
            break;
        case 2:
        	f=2.0f;
            break;
        case 3:
        	f=2.1f;
            break;
        default:
            break;
		}
		return (int)(atk*f);
	}
	
	public int getMaxLvLife(){
		float f=0;
		switch (type) {
        case 1:
            f=1.9f;
            break;
        case 2:
        	f=2.0f;
            break;
        case 3:
        	f=2.1f;
            break;
        default:
            break;
		}
		return (int)(life*f);
	}
	public int getMaxLife(){
		float f=0;
		switch (type) {
        case 1:
            f=1.9f;
            break;
        case 2:
        	f=2.0f;
            break;
        case 3:
        	f=2.1f;
            break;
        default:
            break;
		}
		return (int)(life*f+life*(f-1)/(20+10*rare)*75);
	}
	
	public int getMultMaxLvDPS(){
		return getMaxLvDPS()*num;
	}
	public int getMultMaxDPS(){
		return getMaxDPS()*num;
	}

}
