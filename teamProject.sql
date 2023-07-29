CREATE TABLE "rec_category" (
	"C_NO"	varchar2(30)	NOT NULL,
	"tier"	varchar2(30)	NOT NULL,
	"cateName"	varchar2(30)	NOT NULL,
	"cateParent"	varchar2(30)	NULL,
	"B_NO"	number	NOT NULL
);

ALTER TABLE "rec_category" ADD CONSTRAINT "PK_REC_CATEGORY" PRIMARY KEY (
	"C_NO"
);
