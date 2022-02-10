function filter()
{
    if(self.GetRootMoveParent() == activator)
    {
        EntFireByHandle(self, "FireUser4", "", 0, activator, activator);
    }
}