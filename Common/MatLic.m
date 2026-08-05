function [ no_lic ] = MatVer(  )  
  if ( version('-release') == '2019a' | version('-release') == '2019b' )      
      no_lic = 1;
  else
      no_lic = 0;
  end
  no_lic = logical(no_lic);
end
