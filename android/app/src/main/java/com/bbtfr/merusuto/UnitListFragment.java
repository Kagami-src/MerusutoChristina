package com.bbtfr.merusuto;

import android.app.Fragment;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.alibaba.fastjson.JSONObject;
import com.avos.avoscloud.AVAnalytics;
import com.alibaba.fastjson.JSONArray;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

public class UnitListFragment extends Fragment {

  private UnitListAdapter mAdapter;
  private int mRare = 0, mElement = 0, mWeapon = 0, mType = 0, mSkin = 0, mGender = 0, mAarea = 0, mAnum = 0, mAge = 0, mServer = 0;
  private int mSortMode = R.id.menu_sort_rare, mLevelMode = R.id.menu_level_zero;
  private int mTemplate = R.id.menu_template_unit;
  private boolean mLike = false;
  private String mQuery = null;
  private String mCountry = null;
  private String mSkill = null;

  private ListView mListView;

  public UnitListFragment() {
    super();
  }

  public int getTemplate() {
    return mTemplate;
  }

  public String getTemplateString() {
    switch (mTemplate) {
      case R.id.menu_template_unit:
        return "units";
      case R.id.menu_template_monster:
        return "monsters";
      default:
        return "";
    }
  }

  public void setTemplate(int template) {
    mTemplate = template;
    mLevelMode = 0;
    resetFilters();
    mAdapter.reload();
  }

  public void setSearchQuery(String query) {
    mQuery = query;
    mAdapter.search();
  }

  public void setCountry(String country) {
    mCountry = country;
    mAdapter.search();
  }

  public void setSkill(String skill) {
    mSkill = skill;
    mAdapter.search();
  }

  public void setRare(int rare) {
    mRare = rare;
    mAdapter.search();
  }

  public void setElement(int element) {
    mElement = element;
    mAdapter.search();
  }

  public void setWeapon(int weapon) {
    mWeapon = weapon;
    mAdapter.search();
  }

  public void setType(int type) {
    mType = type;
    mAdapter.search();
  }

  public void setSkin(int skin) {
    mSkin = skin;
    mAdapter.search();
  }

  public void setGender(int gender) {
    mGender = gender;
    mAdapter.search();
  }
  public void setServer(int server) {
    mServer = server;
    mAdapter.search();
  }
  public void setAge(int age) {
    mAge = age;
    mAdapter.search();
  }

  public void setAarea(int aarea) {
    mAarea = aarea;
    mAdapter.search();
  }

  public void setAnum(int anum) {
    mAnum = anum;
    mAdapter.search();
  }

  public void setLevelMode(int mode) {
    mLevelMode = mode;
    mAdapter.sort();
  }

  public void setSortMode(int mode) {
    mSortMode = mode;
    mAdapter.sort();
  }

  public boolean setLike() {
    mLike = !mLike;
    mAdapter.search();
    return mLike;
  }

  private void resetFilters() {
    mRare = mElement = mWeapon = mType = mSkin = mGender = mAarea = mAnum = mAge =mServer = 0;
    mQuery = mCountry = mSkill = null;
    mLike = false;
  }

  public void reset() {
    resetFilters();
    mAdapter.search();
  }

  public void updateJSONData(boolean force) {
    mAdapter.updateJSONData(force);
  }

  public void scrollToTop() {
    mListView.post(new Runnable() {

      @Override
      public void run() {
        if (mListView.getFirstVisiblePosition() > 10) {
          mListView.setSelection(10);
        }
        mListView.smoothScrollToPosition(0);
      }
    });
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
                           Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_unit_list,
        container, false);
    mListView = (ListView) rootView.findViewById(R.id.unit_list);

    if (savedInstanceState != null) {
      onLoadInstanceState(savedInstanceState);
    }

    mAdapter = new UnitListAdapter();

    mListView.setAdapter(mAdapter);
    mListView.setOnItemClickListener(new ListView.OnItemClickListener() {

      @Override
      public void onItemClick(AdapterView<?> parent, View view,
                              int position, long id) {
        UnitItem item = (UnitItem) mAdapter.getItemById((int) id);

        AVAnalytics.onEvent(getActivity(), "Open", getTemplateString() + " " + id);
        UnitItemDialog dialog = new UnitItemDialog(getActivity(), item, mTemplate);
        dialog.show();
      }
    });

    final ImageButton imageButton = (ImageButton) rootView.findViewById(R.id.totop_btn);
    imageButton.setOnClickListener(new ImageButton.OnClickListener() {

      @Override
      public void onClick(View view) {
        scrollToTop();
      }
    });

    mListView.setOnScrollListener(new ListView.OnScrollListener() {

      @Override
      public void onScroll(AbsListView view, int firstVisibleItem,
                           int visibleItemCount, int totalItemCount) {
        if (firstVisibleItem > 10) {
          if (imageButton.getVisibility() == View.INVISIBLE) {
            Animation in = AnimationUtils.makeInAnimation(getActivity(), false);
            imageButton.startAnimation(in);
            imageButton.setVisibility(View.VISIBLE);
          }
        } else {
          if (imageButton.getVisibility() == View.VISIBLE) {
            Animation out = AnimationUtils.makeOutAnimation(getActivity(), true);
            imageButton.startAnimation(out);
            imageButton.setVisibility(View.INVISIBLE);
          }
        }
      }

      @Override
      public void onScrollStateChanged(AbsListView view, int scrollState) {
        // TODO Auto-generated method stub
      }
    });

    return rootView;
  }

  public void onLoadInstanceState(Bundle savedInstanceState) {
    mRare = savedInstanceState.getInt("rare");
    mElement = savedInstanceState.getInt("element");
    mWeapon = savedInstanceState.getInt("weapon");
    mType = savedInstanceState.getInt("type");
    mAge = savedInstanceState.getInt("age");
    mServer = savedInstanceState.getInt("server");
    mLevelMode = savedInstanceState.getInt("levelMode");
    mSortMode = savedInstanceState.getInt("sortMode");
    mTemplate = savedInstanceState.getInt("template");
    mQuery = savedInstanceState.getString("query");
  }

  @Override
  public void onSaveInstanceState(Bundle savedInstanceState) {
    savedInstanceState.putInt("rare", mRare);
    savedInstanceState.putInt("element", mElement);
    savedInstanceState.putInt("weapon", mWeapon);
    savedInstanceState.putInt("type", mType);
    savedInstanceState.putInt("age", mAge);
    savedInstanceState.putInt("server", mServer);
    savedInstanceState.putInt("levelMode", mLevelMode);
    savedInstanceState.putInt("sortMode", mSortMode);
    savedInstanceState.putInt("template", mTemplate);
    savedInstanceState.putString("query", mQuery);
  }

  private class UnitListAdapter extends BaseAdapter {

    private List<UnitItem> mAllData;
    private List<UnitItem> mDisplayedData;

    public UnitListAdapter() {
      mAllData = new ArrayList<>();
      mDisplayedData = new ArrayList<>();
      reload();
    }

    public void reload() {
      mAllData.clear();
      mDisplayedData.clear();
      notifyDataSetChanged();

      Object data = DataManager.loadLocalJSON(getActivity(), getTemplateString());
      if (data != null) {
        addAllJSONData((JSONArray) data);
        search();
        updateJSONData(false);
      } else {
        updateJSONData(true);
      }
    }

    public void updateJSONData(boolean force) {
      final int template = mTemplate;
      DataManager.loadRemoteJSON(getActivity(), getTemplateString(), force, new DataManager.JSONHandler() {
        @Override
        public void onSuccess(Object data) {
          if (template != mTemplate) return;
          addAllJSONData((JSONArray) data);
          search();
        }
      });
    }

    public void addAllJSONData(JSONArray json) {
      mAllData.clear();
      mDisplayedData.clear();
      notifyDataSetChanged();

      for (Iterator iterator = json.iterator(); iterator.hasNext(); ) {
        JSONObject obj = (JSONObject) iterator.next();
        UnitItem item = new UnitItem(obj);
        mAllData.add(item);
      }

      MainActivity activity = (MainActivity) getActivity();

      switch (mTemplate) {
        case R.id.menu_template_unit:
          ArrayList<String> countries = new ArrayList<>();
          for (UnitItem item : mAllData) {
            if (!countries.contains(item.country)) {
              countries.add(item.country);
            }
          }
          if (activity != null) activity.setCountries(countries);

          break;

        case R.id.menu_template_monster:
          ArrayList<String> skills = new ArrayList<>();
          for (UnitItem item : mAllData) {
            String skill = item.getSkillShortString();
            if (!skills.contains(skill)) {
              skills.add(skill);
            }
          }
          if (activity != null) activity.setSkills(skills);
          break;
      }
    }

    public void search() {
      mDisplayedData.clear();

      for (UnitItem item : mAllData)
        if (
            (mRare == 0 || item.rare == mRare ||
                (mRare == 6 && item.rare > 2) ||
                (mRare == 7 && item.rare > 3)) &&
                (mElement == 0 || item.element == mElement ||
                    (mElement == 6 && item.element > 0 && item.element < 4) ||
                    (mElement == 7 && item.element > 3 && item.element < 6)) &&
                (mWeapon == 0 || item.weapon == mWeapon ||
                    (mWeapon == 8 && item.weapon > 0 && item.weapon < 4) ||
                    (mWeapon == 9 && item.weapon > 3 && item.weapon < 7)) &&
                (mType == 0 || item.type == mType) &&
                (mSkin == 0 || item.skin == mSkin) &&
                (mGender == 0 || item.gender == mGender) &&
                (mServer == 0 || item.server == mServer) &&
                (mAarea == 0 || (mAarea == 1 && item.aarea <= 50) ||
                    (mAarea == 2 && item.aarea > 50 && item.aarea <= 150) ||
                    (mAarea == 3 && item.aarea > 150)) &&
                 (mAge == 0 || (mAge == 1 && item.age <= 0) ||
                     (mAge == 2 && item.age > 0 && item.age <= 10) ||
                     (mAge == 3 && item.age > 10 && item.age <= 15) ||
                     (mAge == 4 && item.age > 15 && item.age <= 20) ||
                     (mAge == 5 && item.age > 20 && item.age <= 25) ||
                     (mAge == 6 && item.age > 25 && item.age <= 30) ||
                     (mAge == 7 && item.age > 30 && item.age <= 35) ||
                     (mAge == 8 && item.age > 35 && item.age <= 40) ||
                     (mAge == 9 && item.age > 40)) &&
                (mAnum == 0 || item.anum == mAnum ||
                    (mAnum == 6 && item.anum > 1 && item.anum < 4) ||
                    (mAnum == 7 && item.anum > 3 && item.anum < 6)) &&
                (mCountry == null || item.country.equals(mCountry)) &&
                (mSkill == null || item.getSkillShortString().equals(mSkill)) &&
                (!mLike || DataManager.checkLike(getActivity(), getTemplateString() + " " + item.id)) &&
                (mQuery == null ||
                    item.name.contains(mQuery) ||
                    item.title.contains(mQuery) ||
                    String.valueOf(item.id).contains(mQuery)
                )
            )
          mDisplayedData.add(item);

      sort();
    }

    public void sort() {
      Collections.sort(mDisplayedData, new Comparator<UnitItem>() {

        @Override
        public int compare(UnitItem lhs, UnitItem rhs) {
          float l = 0f, r = 0f;

          switch (mSortMode) {
            case R.id.menu_sort_rare:
              l = lhs.rare;
              r = rhs.rare;
              break;
            case R.id.menu_sort_dps:
              l = lhs.getDPS(mLevelMode);
              r = rhs.getDPS(mLevelMode);
              break;
            case R.id.menu_sort_mult_dps:
              l = lhs.getMultDPS(mLevelMode);
              r = rhs.getMultDPS(mLevelMode);
              break;
            case R.id.menu_sort_atk:
              l = lhs.getAtk(mLevelMode);
              r = rhs.getAtk(mLevelMode);
              break;
            case R.id.menu_sort_life:
              l = lhs.getLife(mLevelMode);
              r = rhs.getLife(mLevelMode);
              break;
            case R.id.menu_sort_aarea:
              l = lhs.aarea;
              r = rhs.aarea;
              break;
            case R.id.menu_sort_anum:
              l = lhs.anum;
              r = rhs.anum;
              break;
            case R.id.menu_sort_aspd:
              l = rhs.aspd;
              r = lhs.aspd;
              l = l == 0f ? 9999f : l;
              r = r == 0f ? 9999f : r;
              break;
            case R.id.menu_sort_tenacity:
              l = lhs.tenacity;
              r = rhs.tenacity;
              break;
            case R.id.menu_sort_mspd:
              l = lhs.mspd;
              r = rhs.mspd;
              break;
            case R.id.menu_sort_hits:
              l = lhs.hits;
              r = rhs.hits;
              break;
            case R.id.menu_sort_age:
              l = lhs.age;
              r = rhs.age;
              break;
          }

          if (l < r) return 1;
          else if (l == r) return 0;
          else return -1;
        }
      });

      notifyDataSetChanged();
    }

    @Override
    public int getCount() {
      return mDisplayedData.size();
    }

    @Override
    public Object getItem(int position) {
      return mDisplayedData.get(position);
    }

    public Object getItemById(int id) {
      for (UnitItem item : mAllData) {
        if (item.id == id) return item;
      }
      return null;
    }

    @Override
    public long getItemId(int position) {
      return mDisplayedData.get(position).id;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      if (convertView == null) {
        convertView = LayoutInflater.from(parent.getContext())
            .inflate(R.layout.cell_unit_item, null);
      }

      final ImageView thumbnailView = (ImageView) convertView.findViewById(R.id.thumbnail);
      TextView rareView = (TextView) convertView.findViewById(R.id.rare);
      TextView nameView = (TextView) convertView.findViewById(R.id.name);
      ElementView elementView = (ElementView) convertView.findViewById(R.id.element);

      final UnitItem item = (UnitItem) getItem(position);
      convertView.setTag(item);

      final View currentView = convertView;

      thumbnailView.setImageBitmap(DataManager.getDefaultThumbnail(getActivity(), null));
      DataManager.loadBitmap(getActivity(), getTemplateString() + "/thumbnail/" + item.id, null,
              new DataManager.BitmapHandler() {
                @Override
                public void onSuccess(Bitmap bitmap) {
                  if (bitmap != null && currentView.getTag() == item) {
                    thumbnailView.setImageBitmap(bitmap);
                  }
                }
              });

      rareView.setText(item.getRareString());
      elementView.setMode(item.element);
      elementView.setElement(item.fire, item.aqua, item.wind, item.light, item.dark);

      TextView textView;
      textView = (TextView) convertView.findViewById(R.id.text_1);
      textView.setText(String.format("生命: %d\n攻击: %d\n攻距: %d\n攻数: %d",
          item.getLife(mLevelMode), item.getAtk(mLevelMode), item.aarea, item.anum));

      switch (mTemplate) {
        case R.id.menu_template_unit:
          nameView.setText(item.title + item.name);

          textView = (TextView) convertView.findViewById(R.id.text_2);
          textView.setText(String.format("攻速: %.2f\n韧性: %d\n移速: %d\n多段: %d",
              item.aspd, item.tenacity, item.mspd, item.hits));

          textView = (TextView) convertView.findViewById(R.id.text_3);
          textView.setText(String.format("成长: %s\n火: %s\n水: %s\n风: %s",
              item.getTypeString(),
              UnitItem.getElementString(item.fire), UnitItem.getElementString(item.aqua),
              UnitItem.getElementString(item.wind)));

          textView = (TextView) convertView.findViewById(R.id.text_4);
          textView.setText(String.format("光: %s\n暗: %s\nDPS: %d\n总DPS: %d",
              UnitItem.getElementString(item.light), UnitItem.getElementString(item.dark),
              item.getDPS(mLevelMode), item.getMultDPS(mLevelMode)));

          break;

        case R.id.menu_template_monster:
          nameView.setText(item.name);

          textView = (TextView) convertView.findViewById(R.id.text_2);
          textView.setText(String.format("攻速: %.2f\n韧性: %d\n移速: %d\n皮肤: %s",
              item.aspd, item.tenacity, item.mspd, item.getSkinString()));

          textView = (TextView) convertView.findViewById(R.id.text_3);
          textView.setText(String.format("技能SP: %d\n技能CD: %d\n技能: %s",
              item.sklsp, item.sklcd, item.getSkillShortString()));

          textView = (TextView) convertView.findViewById(R.id.text_4);
          textView.setText(String.format("\n\nDPS: %d\n总DPS: %d",
              item.getDPS(mLevelMode), item.getMultDPS(mLevelMode)));

          break;
      }

      return convertView;
    }
  }
}
