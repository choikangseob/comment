package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface boardDAO {
	void insert(String a,String b,String c);
	ArrayList<boardDTO> getList(int start);
	int getCount();
	boardDTO getView(int x);
	void delete(int p,String y);
	void update(int x,String y,String z);
	void addHit(int x);
	void addtext(String x,String y,String z);
	void deleteBoard(int x);
	void updateBoard(int x ,String y,String z);
}
