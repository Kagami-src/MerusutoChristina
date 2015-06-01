package com.bbtfr.merusuto;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.avos.avoscloud.AVAnalytics;

import java.util.ArrayList;

public class UnitItemDialog extends Dialog {
  private UnitItem mItem;
  private int mTemplate;

  private ArrayList<View> mViewList;
  private PagerAdapter mPagerAdapter;
  private ViewPager mViewPager;
  private LinePageIndicator mPageIndicator;

  private ZoomImageView mImageView;
  private View mLoadingView;

  private boolean mLike;

  public UnitItemDialog(Context context, UnitItem item, int template) {
    super(context, R.style.NobackgroundDialog);
    mItem = item;
    mTemplate = template;
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

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.dialog_unit_item);

    getWindow().setLayout(LayoutParams.MATCH_PARENT,
        LayoutParams.MATCH_PARENT);

    mViewList = new ArrayList<>();

    final LayoutInflater layoutInflater = LayoutInflater.from(getContext());

    BitmapFactory.Options options = new BitmapFactory.Options();
    options.inScaled = true;
    options.inDensity = 100;
    options.inTargetDensity = 150;

    DataManager.loadBitmap(getContext(), getTemplateString() + "/original/" + mItem.id, options, new DataManager.BitmapHandler() {
      @Override
      public void onSuccess(Bitmap bitmap) {
        if (bitmap != null) {
          mImageView = (ZoomImageView) layoutInflater.inflate(R.layout.view_zoom_image, null);
          mImageView.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
              dismiss();
            }
          });
          mImageView.setImageBitmap(bitmap);
          if (mLoadingView != null) {
            mViewList.set(0, mImageView);
            mPagerAdapter.notifyDataSetChanged();
//            mViewPager.setAdapter(mPagerAdapter);
            View loadingView = mLoadingView.findViewById(R.id.loading);
            loadingView.setVisibility(View.GONE);
          }
        } else {
          if (mLoadingView != null) {
            View progressBar = mLoadingView.findViewById(R.id.loading_progressbar);
            progressBar.setVisibility(View.GONE);
            TextView textView = (TextView) mLoadingView.findViewById(R.id.loading_text);
            textView.setText("网络错误，请稍候重试...");
          }
        }
      }
    });


    View detailView = layoutInflater.inflate(R.layout.view_detail, null);
    detailView.setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
        dismiss();
      }
    });

    Button feedbackButton = (Button) detailView.findViewById(R.id.feedback);
    feedbackButton.setOnClickListener(new Button.OnClickListener() {

      @Override
      public void onClick(View v) {
        try {
          String url = DataManager.BASEURL + "../desktop/#units/" + mItem.id + "/edit";
          Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
          getContext().startActivity(intent);
        } catch (Exception e) {
          Toast.makeText(getContext(), "未找到内置网页浏览器...",
              Toast.LENGTH_SHORT).show();
        }
      }
    });

    final String key = getTemplateString() + " " + mItem.id;
    mLike = DataManager.checkLike(getContext(), key);

    final Button likeButton = (Button) detailView.findViewById(R.id.like);
    if (mLike) likeButton.setText("★ 已收藏");
    likeButton.setOnClickListener(new Button.OnClickListener() {

      @Override
      public void onClick(View v) {
        mLike = !mLike;
        DataManager.storeLike(getContext(), key, mLike);
        if (mLike) {
          AVAnalytics.onEvent(getContext(), "Like", key);
          likeButton.setText("★ 已收藏");
        } else {
          AVAnalytics.onEvent(getContext(), "DisLike", key);
          likeButton.setText("☆ 收藏");
        }
      }
    });

    TextView rareView = (TextView) detailView.findViewById(R.id.rare);
    TextView nameView = (TextView) detailView.findViewById(R.id.name);
    TextView idView = (TextView) detailView.findViewById(R.id.identity);

    UnitItem item = mItem;
    rareView.setText(item.getRareString());
    idView.setText("ID: " + item.id);

    TextView textView;

    switch (mTemplate) {
      case R.id.menu_template_unit:
        nameView.setText(item.title + item.name);

        textView = (TextView) detailView.findViewById(R.id.text_1);
        textView.setText(String.format("初始生命: %d\n满级生命: %d\n满觉生命: %d\n初始攻击: %d\n满级攻击: %d\n满觉攻击: %d",
            item.getLife(R.id.menu_level_zero), item.getLife(R.id.menu_level_max_lv), item.getLife(R.id.menu_level_max_lv_gr),
            item.getAtk(R.id.menu_level_zero), item.getAtk(R.id.menu_level_max_lv), item.getAtk(R.id.menu_level_max_lv_gr)));

        textView = (TextView) detailView.findViewById(R.id.text_2);
        textView.setText(String.format("攻距: %d\n攻数: %d\n攻速: %.2f\n韧性: %d\n移速: %d\n成长: %s",
            item.aarea, item.anum, item.aspd, item.tenacity, item.mspd, item.getTypeString()));

        textView = (TextView) detailView.findViewById(R.id.text_3);
        textView.setText(String.format("初始DPS: %d\n满级DPS: %d\n满觉DPS: %d\n初始总DPS: %d\n满级总DPS: %d\n满觉总DPS: %d",
            item.getDPS(R.id.menu_level_zero), item.getDPS(R.id.menu_level_max_lv), item.getDPS(R.id.menu_level_max_lv_gr),
            item.getMultDPS(R.id.menu_level_zero), item.getMultDPS(R.id.menu_level_max_lv), item.getMultDPS(R.id.menu_level_max_lv_gr)));

        textView = (TextView) detailView.findViewById(R.id.text_4);
        textView.setText(String.format("火: %s\n水: %s\n风: %s\n光: %s\n暗: %s",
            UnitItem.getElementString(item.fire), UnitItem.getElementString(item.aqua),
            UnitItem.getElementString(item.wind), UnitItem.getElementString(item.light),
            UnitItem.getElementString(item.dark)));

        textView = (TextView) detailView.findViewById(R.id.text_5);
        textView.setText(String.format("国家: %s\n性别: %s\n年龄: %s",
            item.country, item.getGenderString(), item.getAgeString()));

        textView = (TextView) detailView.findViewById(R.id.text_6);
        textView.setText(String.format("职业: %s\n兴趣: %s\n性格: %s",
            item.career, item.interest, item.nature));

        textView = (TextView) detailView.findViewById(R.id.text_7);
        textView.setText(String.format("获取方式: %s", item.obtain));

        textView = (TextView) detailView.findViewById(R.id.text_8);
        if (item.remark.equals("暂缺")) {
          textView.setVisibility(View.GONE);
        } else {
          textView.setText(String.format("备注: %s", item.remark));
        }

        detailView.findViewById(R.id.text_9).setVisibility(View.GONE);

        textView = (TextView) detailView.findViewById(R.id.text_10);
        if (item.contributors == null || item.contributors.size() == 0) {
          textView.setVisibility(View.GONE);
        } else {
          textView.setText(String.format("数据提供者: %s", item.getContributorsString()));
        }

        break;

      case R.id.menu_template_monster:
        nameView.setText(item.name);

        textView = (TextView) detailView.findViewById(R.id.text_1);
        textView.setText(String.format("初始生命: %d\n1.7 生命: %d\n1.8 生命: %d\n初始攻击: %d\n1.7 攻击: %d\n1.8 攻击: %d",
            item.getLife(R.id.menu_level_sm), item.getLife(R.id.menu_level_xl), item.getLife(R.id.menu_level_xxl),
            item.getAtk(R.id.menu_level_sm), item.getAtk(R.id.menu_level_xl), item.getAtk(R.id.menu_level_xxl)));

        textView = (TextView) detailView.findViewById(R.id.text_2);
        textView.setText(String.format("攻距: %d\n攻数: %d\n攻速: %.2f\n韧性: %d\n移速: %d\n成长: %s",
            item.aarea, item.anum, item.aspd, item.tenacity, item.mspd, item.getTypeString()));

        textView = (TextView) detailView.findViewById(R.id.text_3);
        textView.setText(String.format("初始DPS: %d\n1.7 DPS: %d\n1.8 DPS: %d\n初始总DPS: %d\n1.7 总DPS: %d\n1.8 总DPS: %d",
            item.getDPS(R.id.menu_level_sm), item.getDPS(R.id.menu_level_xl), item.getDPS(R.id.menu_level_xxl),
            item.getMultDPS(R.id.menu_level_sm), item.getMultDPS(R.id.menu_level_xl), item.getMultDPS(R.id.menu_level_xxl)));

        textView = (TextView) detailView.findViewById(R.id.text_4);
        textView.setText(String.format("火: %s\n水: %s\n风: %s\n光: %s\n暗: %s",
            UnitItem.getElementString(item.fire), UnitItem.getElementString(item.aqua),
            UnitItem.getElementString(item.wind), UnitItem.getElementString(item.light),
            UnitItem.getElementString(item.dark)));

        detailView.findViewById(R.id.text_layout3).setVisibility(View.GONE);
        detailView.findViewById(R.id.text_7).setVisibility(View.GONE);

        textView = (TextView) detailView.findViewById(R.id.text_8);
        textView.setText(String.format("技能: \n技能SP: %d\n技能CD: %d\n%s",
            item.sklsp, item.sklcd, item.skill));

        textView = (TextView) detailView.findViewById(R.id.text_9);
        textView.setText(String.format("获取方式: \n%s", item.obtain));

        textView = (TextView) detailView.findViewById(R.id.text_10);
        if (item.contributors == null || item.contributors.size() == 0) {
          textView.setVisibility(View.GONE);
        } else {
          textView.setText(String.format("数据提供者: %s", item.getContributorsString()));
        }

        break;
    }

    mViewPager = (ViewPager) findViewById(R.id.view_pager);

    if (mImageView != null) {
      mViewList.add(mImageView);
      mViewList.add(detailView);
    } else {
      mLoadingView = layoutInflater.inflate(R.layout.view_loading, null);
      mLoadingView.setOnClickListener(new View.OnClickListener() {

        @Override
        public void onClick(View v) {
          dismiss();
        }
      });
      mViewList.add(mLoadingView);
      mViewList.add(detailView);
    }

    mPagerAdapter = new PagerAdapter() {

      @Override
      public boolean isViewFromObject(View arg0, Object arg1) {
        return arg0 == arg1;
      }

      @Override
      public int getCount() {
        return mViewList.size();
      }

      @Override
      public void destroyItem(ViewGroup container, int position,
                              Object object) {
        container.removeView(mViewList.get(position));
      }

      @Override
      public int getItemPosition(Object object) {
        return POSITION_NONE;
      }

      @Override
      public Object instantiateItem(ViewGroup container, int position) {
        View view = mViewList.get(position);
        container.addView(view);
        return view;
      }
    };

    mViewPager.setAdapter(mPagerAdapter);

    mPageIndicator = (LinePageIndicator) findViewById(R.id.page_indicator);
    mPageIndicator.setViewPager(mViewPager);
  }

  @Override
  public boolean dispatchTouchEvent(MotionEvent event) {
    try {
      if (mImageView != null && mViewPager.getCurrentItem() == 0 && mImageView.onTouchEvent(event)) {
        if (mImageView.inBounds()) {
          if (mPageIndicator.getVisibility() == View.INVISIBLE) {
            Animation in = AnimationUtils.loadAnimation(getContext(), android.R.anim.fade_in);
            mPageIndicator.startAnimation(in);
            mPageIndicator.setVisibility(View.VISIBLE);
          }
        } else {
          if (mPageIndicator.getVisibility() == View.VISIBLE) {
            Animation out = AnimationUtils.loadAnimation(getContext(), android.R.anim.fade_out);
            mPageIndicator.startAnimation(out);
            mPageIndicator.setVisibility(View.INVISIBLE);
          }
        }
      } else {
        return super.dispatchTouchEvent(event);
      }
    } catch (Exception e) {
    }
    return true;
  }
}
