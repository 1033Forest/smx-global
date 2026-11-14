local t = Def.ActorFrame {
	Def.Sprite {
		Texture="materials/_lift";
		Frame0000=0;
		Delay0000=1;		
		InitCommand=function(self)
			self:y(10):zoom(10/7)
		end;
	};
};
return t;