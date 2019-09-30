package function

import (
	"fmt"
	"strings"
	"github.com/hashicorp/go-hclog"
	"github.com/jmoiron/sqlx"
	"github.com/nicholasjackson/env"
	_ "github.com/lib/pq"
)

var logger hclog.Logger

var databaseHost = env.String("POSTGRES_HOST", false, "localhost", "Host of the PostgreSQL server")
var databasePort = env.Int("POSTGRES_PORT", false, 5432, "Port of the PostgreSQL server")
var databaseUser = env.String("POSTGRES_USER", true, "", "Username of the PostgreSQL database")
var databasePassword = env.String("POSTGRES_PASSWORD", true, "", "Password of the PostgreSQL database")
var databaseName = env.String("POSTGRES_DATABASE", true, "", "Name of the PostgreSQL database")

// Report models the 311 report
type Report struct {
	ID         string `db:"id"`
	Agency     string `db:"agency"`
	Complaint  string `db:"complaint"`
	Descriptor string `db:"descriptor"`
	Street     string `db:"street"`
	Borough    string `db:"borough"`
}

// GetReportsForBorough gets a list of reports for borough
func GetReportsForBorough(d *sqlx.DB, borough string) ([]Report, error) {
	var reports []Report
	query := fmt.Sprintf("SELECT complaint FROM halloween WHERE borough = '%s'", borough)
	err := d.Select(&reports, query)

	if err != nil {
		logger.Error("Query report", "error", err)
		return reports, err
	}

	return reports, nil
}

// Handle a serverless request
func Handle(req []byte) string {
	logger = hclog.Default()

	env.Parse()

	datasource := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", *databaseHost, *databasePort, *databaseUser, *databasePassword, *databaseName)
	database, err := sqlx.Connect("postgres", datasource)
	if err != nil {
		logger.Error("Connecting to postgres", "error", err)
	}

	borough := strings.ToUpper(string(req))

	reports, err := GetReportsForBorough(database, borough)
	if err != nil {
		logger.Error("Connecting to postgres", "error", err)
	}

	return fmt.Sprintf("There were %d complaints filed in New York City's %s borough during Halloween 2018.", len(reports), borough)
}