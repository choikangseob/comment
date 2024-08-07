package com.himedia.mc;

import lombok.Data;

@Data
public class commentDTO {
int id;
int par_id;
String content;
int writer;
String userid;
String created;
String updated;
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public int getPar_id() {
	return par_id;
}
public void setPar_id(int par_id) {
	this.par_id = par_id;
}
public String getContent() {
	return content;
}
public void setContent(String content) {
	this.content = content;
}
public int getWriter() {
	return writer;
}
public void setWriter(int writer) {
	this.writer = writer;
}
public String getUserid() {
	return userid;
}
public void setUserid(String userid) {
	this.userid = userid;
}
public String getCreated() {
	return created;
}
public void setCreated(String created) {
	this.created = created;
}
public String getUpdated() {
	return updated;
}
public void setUpdated(String updated) {
	this.updated = updated;
}

}
