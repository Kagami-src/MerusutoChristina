package com.kagami.merusuto;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.graphics.Path;
import android.graphics.PointF;
import android.util.AttributeSet;
import android.view.View;

public class ElementView extends View {
	

	private float fire;
	private float aqua;
	private float wind;
	private float light;
	private float dark;
	private Paint mPaint;
	private PointF[] boundPoints;
	private Path boundPath;
	private Path halfBoundPath;
	private Path elementBoundPath;
	public ElementView(Context context) {
		super(context);
		init();
	}
	public ElementView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}
	private void init(){
		mPaint=new Paint(Paint.ANTI_ALIAS_FLAG);
		mPaint.setStyle(Style.STROKE);
		boundPoints=new PointF[5];
		boundPath=new Path();
		halfBoundPath=new Path();
		elementBoundPath=new Path();
	}
	
	
	private PointF getPoint(float centerX,float centerY ,float r,int i){
	    double th=(Math.PI*2)/360;
	    PointF point=new PointF((float)(centerX + r * Math.cos((-i * 72+90)*th)),
	                              (float)(centerY - r * Math.sin((-i * 72+90)*th)));
	   return point;
	}
	public void setElement(float fire,float aqua,float wind,float light,float dark){
		this.fire=fire;
		this.aqua=aqua;
		this.wind=wind;
		this.light=light;
		this.dark=dark;
	}
	@Override
	protected void onSizeChanged(int w, int h, int oldw, int oldh) {
		float centerX = getWidth()/2.0f;
	    float centerY = getHeight()/2.0f;
	    float r=Math.min(centerX, centerY)-5;
	    boundPoints=new PointF[5];
	   // float th=(M_PI*2)/360;
	    for (int i = 0; i < 5; i ++)
	        boundPoints[i]=getPoint(centerX,centerY,r,i);
	    boundPath.reset();
	    boundPath.moveTo(boundPoints[0].x, boundPoints[0].y);
	    for(int i=1;i<5;i++)
	    	boundPath.lineTo(boundPoints[i].x, boundPoints[i].y);
	    boundPath.close();
	    
	    //half
	    halfBoundPath.reset();
	    PointF tmpPoint=getPoint(centerX,centerY,r/2.0f,0);
	    halfBoundPath.moveTo(tmpPoint.x, tmpPoint.y);
	    for(int i=1;i<5;i++){
	    	tmpPoint=getPoint(centerX,centerY,r/2.0f,i);
	    	halfBoundPath.lineTo(tmpPoint.x, tmpPoint.y);
	    }
	    halfBoundPath.close();
	}
	@Override
	protected void onDraw(Canvas canvas) {
		mPaint.setStyle(Style.STROKE);
		mPaint.setColor(0xaa000000);
		canvas.drawPath(boundPath, mPaint);
		mPaint.setStyle(Style.FILL);
		mPaint.setColor(0x44000000);
		canvas.drawPath(halfBoundPath, mPaint);
		
		//Element
		mPaint.setStyle(Style.FILL);
		mPaint.setColor(0x44ff0000);
		float centerX = getWidth()/2.0f;
	    float centerY = getHeight()/2.0f;
	    float r=Math.min(centerX, centerY)-5;
	    elementBoundPath.reset();
	    PointF tmpPoint=getPoint(centerX, centerY, r/2.0f*fire, 0);
	    elementBoundPath.moveTo(tmpPoint.x, tmpPoint.y);
	    tmpPoint=getPoint(centerX, centerY, r/2.0f*aqua, 1);
	    elementBoundPath.lineTo(tmpPoint.x, tmpPoint.y);
	    tmpPoint=getPoint(centerX, centerY, r/2.0f*wind, 2);
	    elementBoundPath.lineTo(tmpPoint.x, tmpPoint.y);
	    tmpPoint=getPoint(centerX, centerY, r/2.0f*light, 3);
	    elementBoundPath.lineTo(tmpPoint.x, tmpPoint.y);
	    tmpPoint=getPoint(centerX, centerY, r/2.0f*dark, 4);
	    elementBoundPath.lineTo(tmpPoint.x, tmpPoint.y);
	    elementBoundPath.close();
	    canvas.drawPath(elementBoundPath, mPaint);
		
		//Circle
		mPaint.setStyle(Style.FILL);
		mPaint.setColor(Color.RED);
		canvas.drawCircle(boundPoints[0].x, boundPoints[0].y, 5, mPaint);
		mPaint.setColor(Color.BLUE);
		canvas.drawCircle(boundPoints[1].x, boundPoints[1].y, 5, mPaint);
		mPaint.setColor(Color.GREEN);
		canvas.drawCircle(boundPoints[2].x, boundPoints[2].y, 5, mPaint);
		mPaint.setColor(Color.YELLOW);
		canvas.drawCircle(boundPoints[3].x, boundPoints[3].y, 5, mPaint);
		mPaint.setColor(Color.DKGRAY);
		canvas.drawCircle(boundPoints[4].x, boundPoints[4].y, 5, mPaint);
	    

	}

}
