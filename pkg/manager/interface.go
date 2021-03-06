package manager

import "github.com/miekg/vks/pkg/unit"

// Manager manages systemd units.
type Manager interface {
	// this is an interface mostly for testing.
	Disable(name string) error
	Load(name string, u unit.File) error
	Properties(name string) (map[string]interface{}, error)
	Property(name, property string) string
	Reload() error
	ServiceProperty(name, property string) string
	State(name string) (*unit.State, error)
	States(prefix string) (map[string]*unit.State, error)
	TriggerStart(name string) error
	TriggerStop(name string) error
	Unit(name string) string
	Units() ([]string, error)
	Unload(name string) error
}
