function SetDefAnimation(animationName)EntFireByHandle(Model,"SetDefaultAnimation",animationName.tostring(),0.01,null,null);
function SetAnimation(animationName)EntFireByHandle(Model,"SetAnimation",animationName.tostring(),0.00,null,null);
function PlayNewSound(who,SoundName,time)
{
    EntFireByHandle(who,"Volume","0",time+0,null,null);
    EntFireByHandle(who,"StopSound","",time+0,null,null);
    EntFireByHandle(who,"AddOutPut","message "+SoundName+".mp3",time+0,null,null);
    EntFireByHandle(who,"Volume","10",time+0.01,null,null);
    EntFireByHandle(who,"PlaySound","",time+0.01,null,null);
}

RandomSound <- [];
function PushSounds(size)
{
    RandomSound.clear();
    for (local i=1; i<size; i++)
    {
        RandomSound.push(s_Random+i);
    }
}