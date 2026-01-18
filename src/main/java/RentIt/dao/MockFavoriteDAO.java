package RentIt.dao;

import RentIt.models.Property;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Mock FavoriteDAO for deployment without database.
 * Uses HTTP session to store favorites in memory.
 *
 * Usage in JSP:
 *   MockFavoriteDAO favoriteDAO = new MockFavoriteDAO(session);
 *
 * @version 1.0
 */
public class MockFavoriteDAO extends FavoriteDAO {

    private static final String SESSION_KEY_PREFIX = "userFavorites_";
    private HttpSession session;

    /**
     * Constructor requiring HTTP session for storage
     *
     * @param session the HTTP session
     */
    public MockFavoriteDAO(HttpSession session) {
        this.session = session;
    }

    /**
     * Get the session key for a user's favorites
     */
    private String getSessionKey(int userId) {
        return SESSION_KEY_PREFIX + userId;
    }

    /**
     * Get favorites set from session, creating if not exists
     */
    @SuppressWarnings("unchecked")
    private Set<Integer> getFavoritesSet(int userId) {
        String key = getSessionKey(userId);
        Set<Integer> favorites = (Set<Integer>) session.getAttribute(key);
        if (favorites == null) {
            favorites = new LinkedHashSet<>(); // Maintains insertion order
            session.setAttribute(key, favorites);
        }
        return favorites;
    }

    @Override
    public boolean addFavorite(int userId, int propertyId) throws Exception {
        Set<Integer> favorites = getFavoritesSet(userId);
        boolean added = favorites.add(propertyId);
        session.setAttribute(getSessionKey(userId), favorites);
        return added;
    }

    @Override
    public boolean removeFavorite(int userId, int propertyId) throws Exception {
        Set<Integer> favorites = getFavoritesSet(userId);
        boolean removed = favorites.remove(propertyId);
        session.setAttribute(getSessionKey(userId), favorites);
        return removed;
    }

    @Override
    public boolean isFavorite(int userId, int propertyId) throws Exception {
        Set<Integer> favorites = getFavoritesSet(userId);
        return favorites.contains(propertyId);
    }

    @Override
    public Set<Integer> getFavoritesByUser(int userId) throws Exception {
        return new HashSet<>(getFavoritesSet(userId));
    }

    @Override
    public List<Property> getFavoriteProperties(int userId) throws Exception {
        Set<Integer> favoriteIds = getFavoritesSet(userId);
        List<Property> properties = new ArrayList<>();
        
        if (favoriteIds.isEmpty()) {
            return properties;
        }

        // Use MockPropertyDAO to get property details
        MockPropertyDAO propertyDAO = new MockPropertyDAO();
        
        // Get properties in reverse order (most recently added first)
        List<Integer> idList = new ArrayList<>(favoriteIds);
        Collections.reverse(idList);
        
        for (Integer propertyId : idList) {
            Property property = propertyDAO.getPropertyById(propertyId);
            if (property != null) {
                properties.add(property);
            }
        }
        
        return properties;
    }

    @Override
    public int getFavoriteCount(int userId) throws Exception {
        return getFavoritesSet(userId).size();
    }
}
