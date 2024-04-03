const { syncDb } = require("../../tasks/sync-db");


describe('sync-db', () => {
    test("debe ejecutar el proceso 2 veces", () => {
        syncDb();
        const times  = syncDb();
        console.log("Se llamo a syncDb", times);

        expect(times).toBe(2);
    });
});