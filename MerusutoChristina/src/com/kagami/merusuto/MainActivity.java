package com.kagami.merusuto;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;

import org.json.JSONObject;

import android.app.Activity;
import android.app.ActionBar;
import android.app.Fragment;
import android.os.Bundle;
import android.util.JsonReader;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;

public class MainActivity extends Activity {

	private ListContentFragment mContentFragment;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

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
			break;
		case R.id.menu_rare1:
			mContentFragment.setRare(1);
			break;
		case R.id.menu_rare2:
			mContentFragment.setRare(2);
			break;
		case R.id.menu_rare3:
			mContentFragment.setRare(3);
			break;
		case R.id.menu_rare4:
			mContentFragment.setRare(4);
			break;
		case R.id.menu_rare5:
			mContentFragment.setRare(5);
			break;
		case R.id.menu_e0:
			mContentFragment.setElement(0);
			break;
		case R.id.menu_e1:
			mContentFragment.setElement(1);
			break;
		case R.id.menu_e2:
			mContentFragment.setElement(2);
			break;
		case R.id.menu_e3:
			mContentFragment.setElement(3);
			break;
		case R.id.menu_e4:
			mContentFragment.setElement(4);
			break;
		case R.id.menu_e5:
			mContentFragment.setElement(5);
			break;
		default:
			break;
		}
		mContentFragment.search();
		return super.onOptionsItemSelected(item);
	}

	/**
	 * A placeholder fragment containing a simple view.
	 */
	public static class PlaceholderFragment extends Fragment {

		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_main, container,
					false);
			JSONObject js=Utils.readData(getActivity());
				Log.d("kagami", js.toString());
			
			
			return rootView;
		}
	}

}
