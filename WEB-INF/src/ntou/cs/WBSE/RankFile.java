package ntou.cs.WBSE;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.lang.IllegalStateException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Scanner;
import java.util.StringTokenizer;

public class RankFile {
	
	private Scanner input;
	private String filename;
	
	public RankFile(String name){
		filename = name;
	}

	public void openFile ()
	{
		try
		{
			input = new Scanner(new File(filename), "utf-8");
		}
		catch (FileNotFoundException fileNotFoundException)
		{
			System.err.println("Error opening file.");
			System.exit(1);
		}
	}
	
	public ArrayList<Grade> readGrades ()
	{
		Grade grade;
		ArrayList<Grade> gList = new ArrayList<Grade>();
		try
		{
			while (input.hasNext())
			{
				StringTokenizer tokens = new StringTokenizer(input.nextLine());
				String nameTmp = "";
				int nameCount = 0;
				grade = new Grade();
				
				String token = tokens.nextToken();	//ID
				grade.getUser().setID(token);
				
				token = tokens.nextToken();			//Name
				while(!token.startsWith("http://")){
					if(nameCount == 0){
						nameTmp += token;
					}
					else{
						nameTmp += " " + token;
					}
					nameCount++;
					token = tokens.nextToken();
				}
				grade.getUser().setName(nameTmp);
				
				
				
				grade.getUser().setImageURL(token);			//img
				
				
				token = tokens.nextToken();
				grade.setMyGrade(Integer.parseInt(token));
				gList.add(grade);
			}
		}
		catch (IllegalStateException stateException)
		{
			System.err.println("Error reading from file.");
			System.exit(1);
		}
		
		return gList;
	}
	
	public void closeFile ()
	{
		if (input != null)
			input.close();
	}
	
	
	public void addGrade(Grade newGrade, ArrayList<Grade> gradeList){
		boolean isSameID = false;
		for(Grade g:gradeList){
			if(newGrade.getUser().getID().equals(g.getUser().getID())){
				isSameID = true;
				if(newGrade.getMyGrade() > g.getMyGrade()){
					g.setMyGrade(newGrade.getMyGrade());
				}
			}
		}
		if(!isSameID){
			gradeList.add(newGrade);
		}
		
		Collections.sort(gradeList, new Comparator<Grade>(){
			@Override
			public int compare(Grade a, Grade b) {
				return -(a.getMyGrade() - b.getMyGrade());
			}
		});
	    
		
		File file = new File(filename);
		try{
			BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),"utf-8"));
			int num = 0;
			for(Grade g : gradeList){
				if(num != 0){
					bufWriter.write("\r\n");
				}
				bufWriter.write(g.writeFile());
				num++;
			}
			bufWriter.close();
		}catch(IOException e){
			e.printStackTrace();
			System.out.println(filename + "寫檔錯誤");
		}
		
	}

}
