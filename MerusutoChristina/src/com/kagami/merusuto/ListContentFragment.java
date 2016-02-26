package com.kagami.merusuto;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.Fragment;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class ListContentFragment extends Fragment {
	private ContentAdapter mAdapter;
	private int mRare=0,mElement=0;
	public final static int SORT_RARE=1;
	public final static int SORT_MAXDPS=2;
	public final static int SORT_MAXLVDPS=3;
	public final static int SORT_MAXLIFE=4;
	public final static int SORT_MAXLVLIFE=5;
	public final static int SORT_MULT_MAXDPS=6;
	public final static int SORT_MULT_MAXLVDPS=7;
	private int mSortMode=SORT_RARE;
	public ListContentFragment(){
		super();
	}
	public void setRare(int rare){
		mRare=rare;
	}
	public void setElement(int element){
		mElement=element;
	}
	public void search(){
		mAdapter.search(mRare, mElement);
		sort(mSortMode);
	}
	public void sort(int mode){
		mSortMode=mode;
		switch (mode) {
		case SORT_RARE:
			mAdapter.sortByRare();
			break;
		case SORT_MAXLIFE:
			mAdapter.sortByMaxLife();
			break;
		case SORT_MAXLVLIFE:
			mAdapter.sortByMaxLvLife();
			break;
		case SORT_MAXDPS:
			mAdapter.sortByMaxDPS();
			break;
		case SORT_MAXLVDPS:
			mAdapter.sortByMaxLvDPS();
			break;
		case SORT_MULT_MAXDPS:
			mAdapter.sortByMultMaxDPS();
			break;
		case SORT_MULT_MAXLVDPS:
			mAdapter.sortByMultMaxLvDPS();
			break;
		default:
			break;
		}
	}
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_listcontent, container,
				false);
		ListView listview=(ListView)rootView.findViewById(R.id.listView1);
		mAdapter=new ContentAdapter();
		listview.setAdapter(mAdapter);
		listview.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Bitmap bitmap=null;
				try {
					 bitmap=BitmapFactory.decodeStream(getResources().getAssets().open("large/"+id+".png"));
				} catch (IOException e) {
					e.printStackTrace();
				}
				if(bitmap==null)
					return ;
				
				AlertDialog.Builder builder=new Builder(getActivity());
				ImageView image=new ImageView(getActivity());
				image.setImageBitmap(bitmap);
				builder.setView(image);
				builder.show();
				//builder.setView(listview)
				
			}
		});
			return rootView;
	}
	
	
	private class ContentAdapter extends BaseAdapter{
		List<UnitItem> mAllData;
		List<UnitItem> mDisplayData;
		public ContentAdapter(){
			mAllData=new ArrayList<>();
			mDisplayData=new ArrayList<>();
			JSONObject js=Utils.readData(getActivity());
			Iterator<?> keys=js.keys();
			while(keys.hasNext()){
				String id=keys.next().toString();
				UnitItem item=new UnitItem(Integer.valueOf(id), js.optJSONObject(id));
				mAllData.add(item);
			}
			mDisplayData.addAll(mAllData);
		}
		
		public void search(int rare,int element){
			mDisplayData.clear();
			
			for(UnitItem item:mAllData)
				if((rare==0||item.rare==rare)
						&&(element==0||item.element==element))
					mDisplayData.add(item);
		}
		public void sortByMaxLvDPS(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMaxLvDPS(),b=rhs.getMaxLvDPS();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByMaxDPS(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMaxDPS(),b=rhs.getMaxDPS();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByMultMaxLvDPS(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMultMaxLvDPS(),b=rhs.getMultMaxLvDPS();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByMultMaxDPS(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMultMaxDPS(),b=rhs.getMultMaxDPS();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByMaxLvLife(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMaxLvLife(),b=rhs.getMaxLvLife();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByMaxLife(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.getMaxLife(),b=rhs.getMaxLife();
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		public void sortByRare(){
			Collections.sort(mDisplayData, new Comparator<UnitItem>() {

				@Override
				public int compare(UnitItem lhs, UnitItem rhs) {
					int a=lhs.rare,b=rhs.rare;
					if(a<b)
						return 1;
					else if(a==b)
						return 0;
					else
						return -1;
				}
			});
			notifyDataSetChanged();
		}
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return mDisplayData.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return mDisplayData.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return mDisplayData.get(position).id;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if(convertView==null){
				convertView=LayoutInflater.from(parent.getContext()).inflate(R.layout.cell_contentlist, null);
				convertView.setTag(new ViewHolder(convertView));
			}
			ViewHolder holder=(ViewHolder)convertView.getTag();
			Bitmap pic=null;
			try {
				pic=BitmapFactory.decodeStream(getResources().getAssets().open("icon/"+getItemId(position)+".png"));
			
			} catch (IOException e) {
				// do nothing
				//e.printStackTrace();
			}
			if(pic==null)
				holder.pic.setImageResource(R.drawable.p0);
			else
				holder.pic.setImageBitmap(pic);
			UnitItem item=(UnitItem)getItem(position);
			holder.name.setText(item.name1+item.name2);
			holder.reach.setText("射程:"+item.reach);
			holder.num.setText("攻数:"+item.num);
			holder.tough.setText("韧性:"+item.tough);
			holder.speed.setText("移速:"+item.speed);
			holder.quick.setText("攻速:"+item.quick);
			holder.type.setText(item.getTypeString());
			holder.rare.setText(item.getRareString());
			holder.elementView.setElement(item.fire, item.aqua, item.wind, item.light, item.dark);
			//life and atk text
			String life,atk;
			switch (mSortMode) {
			case SORT_MAXDPS:
			case SORT_MAXLIFE:
			case SORT_MULT_MAXDPS:
				life=item.getMaxLife()+"(MAX)";
				atk=item.getMaxAtk()+"(MAX)";
				break;
			case SORT_MAXLVDPS:
			case SORT_MAXLVLIFE:
			case SORT_MULT_MAXLVDPS:
				life=item.getMaxLvLife()+"(MAXLV)";
				atk=item.getMaxLvAtk()+"(MAXLV)";
				break;

			default:
				life=""+item.life;
				atk=""+item.atk;
				break;
			}
			holder.life.setText("生命:"+life);
			holder.atk.setText("攻击:"+atk);
			return convertView;
			
		}
		
	}
	
	private class ViewHolder{
		public ImageView pic;
		public TextView life;
		public TextView atk;
		public TextView name;
		public TextView rare;
		public TextView reach;
		public TextView num;
		public TextView quick;
		public TextView type;
		public TextView speed;
		public TextView tough;
		public ElementView elementView;
		public ViewHolder(View convertView){
			pic=(ImageView)convertView.findViewById(R.id.imageView1);
			life=(TextView)convertView.findViewById(R.id.life);
			atk=(TextView)convertView.findViewById(R.id.atk);
			name=(TextView)convertView.findViewById(R.id.name);
			rare=(TextView)convertView.findViewById(R.id.rare);
			reach=(TextView)convertView.findViewById(R.id.reach);
			num=(TextView)convertView.findViewById(R.id.num);
			quick=(TextView)convertView.findViewById(R.id.quick);
			type=(TextView)convertView.findViewById(R.id.type);
			speed=(TextView)convertView.findViewById(R.id.speed);
			tough=(TextView)convertView.findViewById(R.id.tough);
			elementView=(ElementView)convertView.findViewById(R.id.elementView1);
		}
	}
}
