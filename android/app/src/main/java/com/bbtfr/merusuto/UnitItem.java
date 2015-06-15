package com.bbtfr.merusuto;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONArray;

import org.apache.commons.lang3.StringUtils;

public class UnitItem {

  public String name; // 名称
  public int id;
  public int rare; // 稀有度
  public int element; // 属性 1火 2水 3风 4光 5暗

  public float fire; // 火
  public float aqua; // 水
  public float wind; // 风
  public float light; // 光
  public float dark; // 暗

  public String obtain; // 获取方式
  public String remark; // 备注

  public JSONArray contributors; // 贡献者

  // =====
  // 同伴
  public String title; // 称号
  public int atk; // 攻击
  public int life; // 生命
  public int mspd; // 移动速度
  public int tenacity; // 韧性
  public float aspd; // 攻击速度
  public String country; // 国家

  public int weapon; // 武器 1斩击 2突击 3打击 4弓箭 5魔法 6铳弹 7回复
  public int aarea; // 攻击范围
  public int anum; // 攻击数量
  public int hits; // 多段攻击
  public int type; // 类型 1早熟 2平均 3晚成

  public int gender; // 性别
  public int age; // 年龄
  public String career; // 职业
  public String interest; // 兴趣
  public String nature; // 性格
  // =====

  // =====
  // 魔宠
  public int skin; // 皮肤 1坚硬 2常规 3柔软
  public int sklsp; // 技能消耗SP
  public int sklcd; // 技能CD
  public String skill; // 技能描述
  // =====

  public UnitItem(JSONObject json) {
    this.id = getIntValue(json, "id");
    this.name = getString(json, "name");
    this.rare = getIntValue(json, "rare");
    this.element = getIntValue(json, "element");

    this.fire = getFloatValue(json, "fire");
    this.aqua = getFloatValue(json, "aqua");
    this.wind = getFloatValue(json, "wind");
    this.light = getFloatValue(json, "light");
    this.dark = getFloatValue(json, "dark");

    this.title = getString(json, "title");
    this.life = getIntValue(json, "life");
    this.atk = getIntValue(json, "atk");
    this.mspd = getIntValue(json, "mspd");
    this.aspd = getFloatValue(json, "aspd");
    this.tenacity = getIntValue(json, "tenacity");
    this.weapon = getIntValue(json, "weapon");
    this.aarea = getIntValue(json, "aarea");
    this.type = getIntValue(json, "type");
    this.anum = getIntValue(json, "anum");
    this.hits = getIntValue(json, "hits");
    this.country = getString(json, "country");

    this.gender = getIntValue(json, "gender");
    this.age = getIntValue(json, "age");
    this.career = getString(json, "career");
    this.interest = getString(json, "interest");
    this.nature = getString(json, "nature");


    this.skin = getIntValue(json, "skin");
    this.sklsp = getIntValue(json, "sklsp");
    this.sklcd = getIntValue(json, "sklcd");
    this.skill = getString(json, "skill");


    this.obtain = getString(json, "obtain");
    this.remark = getString(json, "remark");
    this.contributors = json.getJSONArray("contributors");
  }

  private int getIntValue(JSONObject json, String key) {
    try {
      return json.getIntValue(key);
    } catch (Exception e) {
      return 0;
    }
  }

  private float getFloatValue(JSONObject json, String key) {
    try {
      return json.getFloatValue(key);
    } catch (Exception e) {
      return 0.0f;
    }
  }

  private String getString(JSONObject json, String key) {
    String str = json.getString(key);
    return str != null ? str : "暂缺";
  }

  private String getCollectionString(String[] keys, int index) {
    if (index >= 1 && index <= keys.length) {
      return keys[index - 1];
    } else {
      return "暂缺";
    }
  }

  public String getRareString() {
    String[] keys = {"★", "★★", "★★★", "★★★★", "★★★★★"};
    return getCollectionString(keys, rare);
  }

  public String getElementString() {
    String[] keys = {"火", "水", "风", "光", "暗"};
    return getCollectionString(keys, element);
  }

  static public String getElementString(float element) {
    return element != 0.0f ? String.format("%.0f%%", element * 100) : "暂缺";
  }

  // =====
  // 同伴
  public String getTypeString() {
    String[] keys = {"早熟", "平均", "晚成"};
    return getCollectionString(keys, type);
  }

  public String getGenderString() {
    String[] keys = {"不明", "男", "女"};
    return getCollectionString(keys, gender);
  }

  public String getAgeString() {
    return age != 0 ? String.format("%s岁", age) : "暂缺";
  }

  private float calcF() {
    return 1.8f + 0.1f * type;
  }

  // 零觉满级
  private int calcMaxLv(int value) {
    return (int) (value * calcF());
  }

  // 满觉满级
  private int calcMaxLvAndGrow(int value) {
    float f = calcF();
    int levelPart = (int) (value * f);
    int growPart = ((int) (value * (f - 1) / (19 + 10 * rare))) *
        5 * (rare == 1 ? 5 : 15);
    return levelPart + growPart;
  }

  private int calcBySize(int value, float size, int mode) {
    switch (mode) {
      case 1:
        return (int) (value * Math.pow(size, 2.36f));
      case 2:
        return (int) (value * size);
      default:
        return value;
    }
  }

  // 满觉满级
  private int calcByLevel(int mode, int value, int extraMode) {
    switch (mode) {
      case R.id.menu_level_zero:
        return value;
      case R.id.menu_level_max_lv:
        return calcMaxLv(value);
      case R.id.menu_level_max_lv_gr:
        return calcMaxLvAndGrow(value);
      case R.id.menu_level_sm:
        return calcBySize(value, 1.0f, extraMode);
      case R.id.menu_level_md:
        return calcBySize(value, 1.35f, extraMode);
      case R.id.menu_level_lg:
        return calcBySize(value, 1.55f, extraMode);
      case R.id.menu_level_xl:
        return calcBySize(value, 1.7f, extraMode);
      case R.id.menu_level_xxl:
        return calcBySize(value, 1.8f, extraMode);
      default:
        return value;
    }
  }

  public int getAtk(int mode) {
    return (int) calcByLevel(mode, atk, 1);
  }

  public int getLife(int mode) {
    return (int) calcByLevel(mode, life, 2);
  }

  public float calcDPS(int mode) {
    if (aspd != 0) {
      return calcByLevel(mode, atk, 1) / aspd;
    } else {
      return 0;
    }
  }

  public int getDPS(int mode) {
    return (int) calcDPS(mode);
  }

  public int getMultDPS(int mode) {
    return (int) calcDPS(mode) * anum;
  }
  // =====

  // =====
  // 魔宠
  public String getSkinString() {
    String[] keys = {"坚硬", "常规", "柔软"};
    return getCollectionString(keys, skin);
  }

  public String getSkillShortString() {
    return skill.split("：")[0].split(" ")[0];
  }
  // =====

  public String getContributorsString() {
    return StringUtils.join(contributors, "、");
  }
}
