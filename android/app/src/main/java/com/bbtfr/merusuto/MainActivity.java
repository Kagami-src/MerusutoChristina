package com.bbtfr.merusuto;

import android.net.Uri;
import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SubMenu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.SearchView;
import android.widget.TextView;
import android.widget.Toast;
import android.graphics.drawable.Drawable;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface.OnClickListener;
import android.content.DialogInterface;

import com.avos.avoscloud.feedback.FeedbackAgent;
import java.util.ArrayList;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class MainActivity extends Activity {

  private UnitListFragment mUnitListFragment;
  private ActionBarDrawerToggle mDrawerToggle;
  private Menu mOptionsMenu;
  private MenuItem mSearchMenu, mCountryFilter, mSkillFilter;
  private ArrayList<String> mCountries, mSkills;
  private boolean mCountryFilterUpdated = false, mSkillFilterUpdated = false;
  private FeedbackAgent mAgent;
  private Context context;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setTheme(R.style.AppTheme);
    setContentView(R.layout.activity_main);

    ActionBar actionBar = getActionBar();
    // actionBar.setDisplayShowHomeEnabled(true);
    actionBar.setDisplayShowTitleEnabled(false);
    actionBar.setDisplayHomeAsUpEnabled(true);
    actionBar.setHomeButtonEnabled(true);
    actionBar.setIcon(R.drawable.ic_logo);

    DrawerListAdapter adapter = new DrawerListAdapter(this);
    PopupMenu popupMenu = new PopupMenu(this, null);
    popupMenu.inflate(R.menu.sidebar);
    Menu menu = popupMenu.getMenu();
    MenuItem menuItem;
    for (int i = 0; i < menu.size(); i++) {
      menuItem = menu.getItem(i);
      adapter.addItem(new DrawerItem(menuItem.getItemId(),
              menuItem.getTitle(), true, menuItem.getIcon()));
      SubMenu subMenu = menuItem.getSubMenu();
      for (int j = 0; j < subMenu.size(); j++) {
        menuItem = subMenu.getItem(j);
        adapter.addItem(new DrawerItem(menuItem.getItemId(),
                menuItem.getTitle(), false, menuItem.getIcon()));
      }
    }

    final ListView drawerList = (ListView) findViewById(R.id.left_drawer);
    final DrawerLayout drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
    drawerLayout.setDrawerShadow(R.drawable.drawer_shadow, GravityCompat.START);

    drawerList.setAdapter(adapter);
    drawerList.setOnItemClickListener(new ListView.OnItemClickListener() {

      @Override
      public void onItemClick(AdapterView parent, View view, int position, long id) {
        drawerLayout.closeDrawer(drawerList);

        int itemId = (int) id;
        switch (itemId) {
          case R.id.menu_template_unit:
          case R.id.menu_template_monster:
            mUnitListFragment.setTemplate(itemId);
            invalidateOptionsMenu();
            break;
          case R.id.menu_load_zip_data:
            try {
              Intent intent = new Intent();
              intent.setAction(Intent.ACTION_GET_CONTENT);
              intent.setType("file/*");
              startActivityForResult(intent, R.id.menu_load_zip_data);
            } catch(Exception e) {
              Toast mToast = Toast.makeText(MainActivity.this, "   未找到内置文件浏览器...", Toast.LENGTH_LONG);
              LinearLayout toastView = (LinearLayout) mToast.getView();
              toastView.setOrientation(LinearLayout.HORIZONTAL);
              ImageView imageCodeProject = new ImageView(getApplicationContext());
              imageCodeProject.setImageResource(R.drawable.warning);
              toastView.addView(imageCodeProject, 0);
              mToast.show();
            }
            break;
          case R.id.menu_user_feedback:
            mAgent.startDefaultThreadActivity();
            break;
          case R.id.menu_check_update:
            Toast mToast = Toast.makeText(MainActivity.this, "   检查版本更新... ", Toast.LENGTH_LONG);
            LinearLayout toastView = (LinearLayout) mToast.getView();
            toastView.setOrientation(LinearLayout.HORIZONTAL);
            ImageView imageCodeProject = new ImageView(getApplicationContext());
            imageCodeProject.setImageResource(R.drawable.loading);
            toastView.addView(imageCodeProject, 0);
            mToast.show();
            Utils.checkUpdate(MainActivity.this, true);
            mUnitListFragment.updateJSONData(true);
            break;
          case R.id.menu_clouddisk_url:
            try {
              String url = "http://bbtfr.github.io/MerusutoChristina/jump/clouddisk.html";
              Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
              MainActivity.this.startActivity(intent);
            } catch (Exception e) {
              Toast.makeText(MainActivity.this, "未找到内置网页浏览器...",
                      Toast.LENGTH_SHORT).show();
            }
            break;
          case R.id.menu_about:
            try {
              String url = "http://bbtfr.github.io/MerusutoChristina/jump/about.html";
              Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
              MainActivity.this.startActivity(intent);
            } catch (Exception e) {
              Toast.makeText(MainActivity.this, "未找到内置网页浏览器...",
                      Toast.LENGTH_SHORT).show();
            }
            break;
          case R.id.menu_delete_data:
            AlertDialog.Builder builder = new Builder(MainActivity.this);
            builder.setMessage("确认清除所有立绘文件吗？");
            builder.setTitle("提示");
            builder.setPositiveButton("确认", new OnClickListener() {
              @Override
              public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                Utils.createDeleteMeruDirTask(MainActivity.this);
              }
            });
            builder.setNegativeButton("取消", new OnClickListener() {
              @Override
              public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
              }
            });
            builder.create().show();
            break;
        }
      }
    });

    mDrawerToggle = new ActionBarDrawerToggle(this, drawerLayout,
            R.drawable.ic_drawer, R.string.drawer_open, R.string.drawer_close);

    drawerLayout.setDrawerListener(mDrawerToggle);

    if (savedInstanceState == null) {
      mUnitListFragment = new UnitListFragment();
      getFragmentManager().beginTransaction()
              .add(R.id.content_frame, mUnitListFragment, "UnitListFragment")
              .commit();

      Utils.checkUpdate(this, false);
    } else {
      mUnitListFragment = (UnitListFragment) getFragmentManager()
              .findFragmentByTag("UnitListFragment");
    }

    mAgent = new FeedbackAgent(this);
    mAgent.sync();
  }

  @Override
  protected void onPostCreate(Bundle savedInstanceState) {
    super.onPostCreate(savedInstanceState);
    mDrawerToggle.syncState();
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    mDrawerToggle.onConfigurationChanged(newConfig);
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    mOptionsMenu = menu;

    switch (mUnitListFragment.getTemplate()) {
      case R.id.menu_template_unit:
        getMenuInflater().inflate(R.menu.options_unit, menu);
        break;
      case R.id.menu_template_monster:
        getMenuInflater().inflate(R.menu.options_monster, menu);
        break;
    }

    mCountryFilter = menu.findItem(R.id.menu_country);
    mSkillFilter = menu.findItem(R.id.menu_skill);
    updateFilters();

    mSearchMenu = menu.findItem(R.id.menu_search);
    mSearchMenu.setOnActionExpandListener(new MenuItem.OnActionExpandListener() {

      public void setMenuItemVisible(boolean visible) {
        MenuItem menuItem;
        menuItem = menu.findItem(R.id.menu_level_mode);
        if (menuItem != null) menuItem.setVisible(visible);
        menuItem = menu.findItem(R.id.menu_sort_mode);
        menuItem.setVisible(visible);
        menuItem = menu.findItem(R.id.menu_filters);
        menuItem.setVisible(visible);
        menuItem = menu.findItem(R.id.menu_close_search);
        menuItem.setVisible(!visible);

        getActionBar().setIcon(visible ? R.drawable.ic_logo :
                android.R.color.transparent);
      }

      @Override
      public boolean onMenuItemActionCollapse(MenuItem item) {
        mUnitListFragment.setSearchQuery(null);
        setMenuItemVisible(true);
        return true;
      }

      @Override
      public boolean onMenuItemActionExpand(MenuItem item) {
        setMenuItemVisible(false);
        return true;
      }
    });

    SearchView searchView = (SearchView) mSearchMenu.getActionView();
    searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
      @Override
      public boolean onQueryTextChange(String query) {
        if (query.isEmpty()) query = null;
        mUnitListFragment.setSearchQuery(query);
        return true;
      }

      @Override
      public boolean onQueryTextSubmit(String query) {
        mUnitListFragment.setSearchQuery(query);
        return true;
      }
    });

    return true;
  }

  public void setCountries(ArrayList<String> countries) {
    mCountries = countries;
    updateCountryFilters();
  }

  public void setSkills(ArrayList<String> skills) {
    mSkills = skills;
    updateSkillFilters();
  }

  public void updateFilters() {
    mCountryFilterUpdated = mSkillFilterUpdated = false;
    updateCountryFilters();
    updateSkillFilters();
  }

  public void updateCountryFilters() {
    if (!mCountryFilterUpdated && mCountries != null && mCountryFilter != null) {
      SubMenu subMenu = mCountryFilter.getSubMenu();
      for (int i = 0; i < mCountries.size(); i++) {
        subMenu.add(R.id.menu_country, i, Menu.NONE, mCountries.get(i));
      }
      mCountryFilterUpdated = true;
    }
  }

  public void updateSkillFilters() {
    if (!mSkillFilterUpdated && mSkills != null && mSkillFilter != null) {
      SubMenu subMenu = mSkillFilter.getSubMenu();
      for (int i = 0; i < mSkills.size(); i++) {
        subMenu.add(R.id.menu_skill, i, Menu.NONE, mSkills.get(i));
      }
      mSkillFilterUpdated = true;
    }
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (mDrawerToggle.onOptionsItemSelected(item)) {
      return true;
    }

    switch (item.getGroupId()) {
      case R.id.menu_country:
        mUnitListFragment.setCountry(item.getTitle().toString());
        setMenuItemEnabledEx(R.id.menu_country, item);
        break;
      case R.id.menu_skill:
        mUnitListFragment.setSkill(item.getTitle().toString());
        setMenuItemEnabledEx(R.id.menu_skill, item);
        break;
    }

    int itemId = item.getItemId();
    switch (itemId) {
      case R.id.menu_close_search:
        mSearchMenu.collapseActionView();
        break;
      case R.id.menu_rare_0:
        mUnitListFragment.setRare(0);
        setMenuItemEnabledEx(R.id.menu_rare);
        break;
      case R.id.menu_rare_1:
      case R.id.menu_rare_2:
      case R.id.menu_rare_3:
      case R.id.menu_rare_4:
      case R.id.menu_rare_5:
      case R.id.menu_rare_6:
      case R.id.menu_rare_7:
        mUnitListFragment.setRare(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_rare, item);
        break;
      case R.id.menu_element_0:
        mUnitListFragment.setElement(0);
        setMenuItemEnabledEx(R.id.menu_element);
        break;
      case R.id.menu_element_1:
      case R.id.menu_element_2:
      case R.id.menu_element_3:
      case R.id.menu_element_4:
      case R.id.menu_element_5:
      case R.id.menu_element_6:
      case R.id.menu_element_7:
        mUnitListFragment.setElement(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_element, item);
        break;
      case R.id.menu_weapon_0:
        mUnitListFragment.setWeapon(0);
        setMenuItemEnabledEx(R.id.menu_weapon);
        break;
      case R.id.menu_weapon_1:
      case R.id.menu_weapon_2:
      case R.id.menu_weapon_3:
      case R.id.menu_weapon_4:
      case R.id.menu_weapon_5:
      case R.id.menu_weapon_6:
      case R.id.menu_weapon_7:
      case R.id.menu_weapon_8:
      case R.id.menu_weapon_9:
        mUnitListFragment.setWeapon(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_weapon, item);
        break;
      case R.id.menu_type_0:
        mUnitListFragment.setType(0);
        setMenuItemEnabledEx(R.id.menu_type);
        break;
      case R.id.menu_type_1:
      case R.id.menu_type_2:
      case R.id.menu_type_3:
        mUnitListFragment.setType(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_type, item);
        break;
      case R.id.menu_gender_0:
        mUnitListFragment.setGender(0);
        setMenuItemEnabledEx(R.id.menu_gender);
        break;
      case R.id.menu_gender_1:
      case R.id.menu_gender_2:
      case R.id.menu_gender_3:
        mUnitListFragment.setGender(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_gender, item);
        break;
      case R.id.menu_server_0:
        mUnitListFragment.setServer(0);
        setMenuItemEnabledEx(R.id.menu_server);
        break;
      case R.id.menu_server_1:
      case R.id.menu_server_2:
        mUnitListFragment.setServer(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_server, item);
        break;
      case R.id.menu_exchange_0:
        mUnitListFragment.setExchange(0);
        setMenuItemEnabledEx(R.id.menu_exchange);
        break;
      case R.id.menu_exchange_1:
      case R.id.menu_exchange_2:
        mUnitListFragment.setExchange(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_exchange, item);
        break;
      case R.id.menu_skin_0:
        mUnitListFragment.setSkin(0);
        setMenuItemEnabledEx(R.id.menu_skin);
        break;
      case R.id.menu_skin_1:
      case R.id.menu_skin_2:
      case R.id.menu_skin_3:
        mUnitListFragment.setSkin(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_skin, item);
        break;
      case R.id.menu_aarea_0:
        mUnitListFragment.setAarea(0);
        setMenuItemEnabledEx(R.id.menu_aarea);
        break;
      case R.id.menu_aarea_1:
      case R.id.menu_aarea_2:
      case R.id.menu_aarea_3:
        mUnitListFragment.setAarea(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_aarea, item);
        break;
      case R.id.menu_age_0:
        mUnitListFragment.setAge(0);
        setMenuItemEnabledEx(R.id.menu_age);
        break;
      case R.id.menu_age_1:
      case R.id.menu_age_2:
      case R.id.menu_age_3:
      case R.id.menu_age_4:
      case R.id.menu_age_5:
      case R.id.menu_age_6:
      case R.id.menu_age_7:
      case R.id.menu_age_8:
      case R.id.menu_age_9:
        mUnitListFragment.setAge(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_age, item);
        break;
      case R.id.menu_anum_0:
        mUnitListFragment.setAnum(0);
        setMenuItemEnabledEx(R.id.menu_anum);
        break;
      case R.id.menu_anum_1:
      case R.id.menu_anum_2:
      case R.id.menu_anum_3:
      case R.id.menu_anum_4:
      case R.id.menu_anum_5:
      case R.id.menu_anum_6:
      case R.id.menu_anum_7:
        mUnitListFragment.setAnum(item.getOrder());
        setMenuItemEnabledEx(R.id.menu_anum, item);
        break;
      case R.id.menu_country_0:
        mUnitListFragment.setCountry(null);
        setMenuItemEnabledEx(R.id.menu_country);
        break;
      case R.id.menu_skill_0:
        mUnitListFragment.setSkill(null);
        setMenuItemEnabledEx(R.id.menu_skill);
        break;
      case R.id.menu_sort_rare:
      case R.id.menu_sort_dps:
      case R.id.menu_sort_sklmax:
      case R.id.menu_sort_mult_dps:
      case R.id.menu_sort_life:
      case R.id.menu_sort_atk:
      case R.id.menu_sort_aarea:
      case R.id.menu_sort_age:
      case R.id.menu_sort_anum:
      case R.id.menu_sort_aspd:
      case R.id.menu_sort_tenacity:
      case R.id.menu_sort_mspd:
      case R.id.menu_sort_hits:
      case R.id.menu_sort_id:
        mUnitListFragment.setSortMode(itemId);
        setMenuItemEnabled(R.id.menu_sort_mode, item);
        break;
      case R.id.menu_level_zero:
      case R.id.menu_level_max_lv:
      case R.id.menu_level_max_lv_gr:
        mUnitListFragment.setLevelMode(itemId);
        setMenuItemEnabled(R.id.menu_level_mode, item);
        break;
      case R.id.menu_like:
        boolean like = mUnitListFragment.setLike();
        String title = item.getTitle().toString().split(" - ")[0];
        if (like) {
          item.setTitle(title + " - 已收藏");
        } else {
          item.setTitle(title);
        }
        break;
      case R.id.menu_reset:
        mUnitListFragment.reset();
        setMenuItemEnabledEx(R.id.menu_filters);
        break;
    }

    return super.onOptionsItemSelected(item);
  }
  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (resultCode != Activity.RESULT_OK) {
      return;
    }

    switch (requestCode) {
      case R.id.menu_load_zip_data:
        String filename = data.getData().getPath();
        Utils.createDecompressTask(this, filename);
        break;
    }
  }

  private void setMenuItemEnabled(int parentId) {
    setMenuItemEnabled(mOptionsMenu.findItem(parentId).getSubMenu());
  }

  private void setMenuItemEnabledEx(int parentId) {
    MenuItem menuItem = mOptionsMenu.findItem(parentId);
    String title = menuItem.getTitle().toString().split(" - ")[0];
    menuItem.setTitle(title);
    setMenuItemEnabled(menuItem.getSubMenu());
  }

  private void setMenuItemEnabled(int parentId, MenuItem item) {
    setMenuItemEnabled(mOptionsMenu.findItem(parentId).getSubMenu());
    item.setEnabled(false);
  }

  private void setMenuItemEnabledEx(int parentId, MenuItem item) {
    MenuItem menuItem = mOptionsMenu.findItem(parentId);
    String title = menuItem.getTitle().toString().split(" - ")[0];
    menuItem.setTitle(title + " - " + item.getTitle());
    setMenuItemEnabled(menuItem.getSubMenu());
    item.setEnabled(false);
  }

  private void setMenuItemEnabled(SubMenu subMenu) {
    if (subMenu != null) {
      for (int i = 0; i < subMenu.size(); i++) {
        MenuItem menuItem = subMenu.getItem(i);
        menuItem.setEnabled(true);
        menuItem.setChecked(false);
        if (menuItem.hasSubMenu()) {
          String title = menuItem.getTitle().toString().split(" - ")[0];
          menuItem.setTitle(title);
          setMenuItemEnabled(menuItem.getSubMenu());
        }
      }
    }
  }

  @Override
  public void onBackPressed() {
    if (!moveTaskToBack(false)) {
      moveTaskToBack(true);
    }
  }

  private class DrawerItem {

    public int id;
    public String title;
    public boolean separator = false;
	public Drawable icon;

    public DrawerItem(int id, CharSequence title, boolean separator, Drawable icon) {
      this.id = id;
      this.title = title.toString();
      this.separator = separator;
	  this.icon = icon;
    }
  }

  private class DrawerListAdapter extends BaseAdapter {

    private ArrayList<DrawerItem> mData = new ArrayList<DrawerItem>();

    private LayoutInflater mInflater;

    public DrawerListAdapter(Context context) {
      mInflater = LayoutInflater.from(context);
    }

    public void addItem(DrawerItem item) {
      mData.add(item);
      notifyDataSetChanged();
    }

    @Override
    public int getCount() {
      return mData.size();
    }

    @Override
    public DrawerItem getItem(int position) {
      return mData.get(position);
    }

    @Override
    public long getItemId(int position) {
      return mData.get(position).id;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
      TextView textView = null;
      if (mData.get(position).separator) {
        convertView = mInflater.inflate(R.layout.drawer_listview_item_separator, null);
        textView = (TextView) convertView.findViewById(R.id.textSeparator);
      } else {
        convertView = mInflater.inflate(R.layout.drawer_listview_item, null);
        textView = (TextView) convertView.findViewById(R.id.text);
      }
      textView.setText(mData.get(position).title);
      Drawable icon = mData.get(position).icon;
      if (icon != null) {
        icon.setBounds(0, 0, 35, 35);
        textView.setCompoundDrawables(icon, null, null, null);
      }

      return convertView;
    }
  }
}