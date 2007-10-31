/*
 *  (C) 2001 by Argonne National Laboratory
 *      See COPYRIGHT in top-level directory.
 */

/*
 *  @author  Anthony Chan
 */

package logformat.slog2;

import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;

import base.drawable.TimeBoundingBox;
import base.drawable.Drawable;

/*
   Iterator of Drawables in a given List in Decreasing StartTime order.
   The drawable returned by next() overlaps with the timeframe specified.
 */
public class IteratorOfBackDrawables implements Iterator
{
    private ListIterator     drawables_itr;
    private TimeBoundingBox  timeframe;
    private Drawable         next_drawable;

    public IteratorOfBackDrawables(       List             dobjs_list,
                                    final TimeBoundingBox  tframe )
    {
        drawables_itr  = dobjs_list.listIterator( dobjs_list.size() );
        timeframe      = tframe;
        next_drawable  = this.getNextInQueue();
    }

    private Drawable getNextInQueue()
    {
        Drawable   next_dobj;
        while ( drawables_itr.hasPrevious() ) {
            next_dobj = (Drawable) drawables_itr.previous();
            if ( next_dobj.overlaps( timeframe ) )
                return next_dobj;
        }
        return null;
    }

    public boolean hasNext()
    {
        return next_drawable != null;
    }

    public Object next()
    {
        Drawable  returning_dobj;

        returning_dobj = next_drawable;
        next_drawable  = this.getNextInQueue();
        return returning_dobj;
    }

    public void remove() {}
}   // private class IteratorOfBackDrawables
