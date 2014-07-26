package com.kagami.merusuto;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class MainActivity extends Activity {

	private ListContentFragment mContentFragment;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		getActionBar().setDisplayShowTitleEnabled(false);
		if (savedInstanceState == null) {
			mContentFragment=new ListContentFragment();
			getFragmentManager().beginTransaction()
					.add(R.id.container, mContentFragment).commit();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		switch (id) {
		case R.id.menu_rare0:
			mContentFragment.setRare(0);
			mContentFragment.search();
			break;
		case R.id.menu_rare1:
			mContentFragment.setRare(1);
			mContentFragment.search();
			break;
		case R.id.menu_rare2:
			mContentFragment.setRare(2);
			mContentFragment.search();
			break;
		case R.id.menu_rare3:
			mContentFragment.setRare(3);
			mContentFragment.search();
			break;
		case R.id.menu_rare4:
			mContentFragment.setRare(4);
			mContentFragment.search();
			break;
		case R.id.menu_rare5:
			mContentFragment.setRare(5);
			mContentFragment.search();
			break;
		case R.id.menu_e0:
			mContentFragment.setElement(0);
			mContentFragment.search();
			break;
		case R.id.menu_e1:
			mContentFragment.setElement(1);
			mContentFragment.search();
			break;
		case R.id.menu_e2:
			mContentFragment.setElement(2);
			mContentFragment.search();
			break;
		case R.id.menu_e3:
			mContentFragment.setElement(3);
			mContentFragment.search();
			break;
		case R.id.menu_e4:
			mContentFragment.setElement(4);
			mContentFragment.search();
			break;
		case R.id.menu_e5:
			mContentFragment.setElement(5);
			mContentFragment.search();
			break;
		case R.id.menu_sort_rare:
			mContentFragment.sort(ListContentFragment.SORT_RARE);
			break;
		case R.id.menu_sort_maxlvdps:
			mContentFragment.sort(ListContentFragment.SORT_MAXLVDPS);
			break;
		case R.id.menu_sort_multmaxlvdps:
			mContentFragment.sort(ListContentFragment.SORT_MULT_MAXLVDPS);
			break;
		case R.id.menu_sort_maxdps:
			mContentFragment.sort(ListContentFragment.SORT_MAXDPS);
			break;
		case R.id.menu_sort_multmaxdps:
			mContentFragment.sort(ListContentFragment.SORT_MULT_MAXDPS);
			break;
		case R.id.menu_sort_maxlvlife:
			mContentFragment.sort(ListContentFragment.SORT_MAXLVLIFE);
			break;
		case R.id.menu_sort_maxlife:
			mContentFragment.sort(ListContentFragment.SORT_MAXLIFE);
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}

	

}
