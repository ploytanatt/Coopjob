// store.js
import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        activeTab: 'overview'
    },
    mutations: {
        setActiveTab(state, tabName) {
            state.activeTab = tabName;
        }
    },
    actions: {
        changeActiveTab({ commit }, tabName) {
            commit('setActiveTab', tabName);
        }
    }
});
