
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Bigtable Admin
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Administer your Cloud Bigtable tables and instances.
## 
## https://cloud.google.com/bigtable/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "bigtableadmin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigtableadminProjectsInstancesClustersUpdate_589008 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesClustersUpdate_589010(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersUpdate_589009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589011 = path.getOrDefault("name")
  valid_589011 = validateParameter(valid_589011, JString, required = true,
                                 default = nil)
  if valid_589011 != nil:
    section.add "name", valid_589011
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589012 = query.getOrDefault("upload_protocol")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "upload_protocol", valid_589012
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("callback")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "callback", valid_589017
  var valid_589018 = query.getOrDefault("access_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "access_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("key")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "key", valid_589020
  var valid_589021 = query.getOrDefault("$.xgafv")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("1"))
  if valid_589021 != nil:
    section.add "$.xgafv", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_BigtableadminProjectsInstancesClustersUpdate_589008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster within an instance.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_BigtableadminProjectsInstancesClustersUpdate_589008;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesClustersUpdate
  ## Updates a cluster within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  var body_589028 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(path_589026, "name", newJString(name))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589028 = body
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, body_589028)

var bigtableadminProjectsInstancesClustersUpdate* = Call_BigtableadminProjectsInstancesClustersUpdate_589008(
    name: "bigtableadminProjectsInstancesClustersUpdate",
    meth: HttpMethod.HttpPut, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesClustersUpdate_589009,
    base: "/", url: url_BigtableadminProjectsInstancesClustersUpdate_589010,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsGet_588719 = ref object of OpenApiRestCall_588450
proc url_BigtableadminOperationsGet_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsGet_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588863 = query.getOrDefault("view")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_588863 != nil:
    section.add "view", valid_588863
  var valid_588864 = query.getOrDefault("quotaUser")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "quotaUser", valid_588864
  var valid_588865 = query.getOrDefault("alt")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = newJString("json"))
  if valid_588865 != nil:
    section.add "alt", valid_588865
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("callback")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "callback", valid_588867
  var valid_588868 = query.getOrDefault("access_token")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "access_token", valid_588868
  var valid_588869 = query.getOrDefault("uploadType")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "uploadType", valid_588869
  var valid_588870 = query.getOrDefault("key")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "key", valid_588870
  var valid_588871 = query.getOrDefault("$.xgafv")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("1"))
  if valid_588871 != nil:
    section.add "$.xgafv", valid_588871
  var valid_588872 = query.getOrDefault("prettyPrint")
  valid_588872 = validateParameter(valid_588872, JBool, required = false,
                                 default = newJBool(true))
  if valid_588872 != nil:
    section.add "prettyPrint", valid_588872
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588895: Call_BigtableadminOperationsGet_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_BigtableadminOperationsGet_588719; name: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588967 = newJObject()
  var query_588969 = newJObject()
  add(query_588969, "upload_protocol", newJString(uploadProtocol))
  add(query_588969, "fields", newJString(fields))
  add(query_588969, "view", newJString(view))
  add(query_588969, "quotaUser", newJString(quotaUser))
  add(path_588967, "name", newJString(name))
  add(query_588969, "alt", newJString(alt))
  add(query_588969, "oauth_token", newJString(oauthToken))
  add(query_588969, "callback", newJString(callback))
  add(query_588969, "access_token", newJString(accessToken))
  add(query_588969, "uploadType", newJString(uploadType))
  add(query_588969, "key", newJString(key))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, nil)

var bigtableadminOperationsGet* = Call_BigtableadminOperationsGet_588719(
    name: "bigtableadminOperationsGet", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsGet_588720, base: "/",
    url: url_BigtableadminOperationsGet_588721, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesPatch_589049 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesAppProfilesPatch_589051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesPatch_589050(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589052 = path.getOrDefault("name")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "name", valid_589052
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when updating the app profile.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  section = newJObject()
  var valid_589053 = query.getOrDefault("upload_protocol")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "upload_protocol", valid_589053
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("ignoreWarnings")
  valid_589057 = validateParameter(valid_589057, JBool, required = false, default = nil)
  if valid_589057 != nil:
    section.add "ignoreWarnings", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("callback")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "callback", valid_589059
  var valid_589060 = query.getOrDefault("access_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "access_token", valid_589060
  var valid_589061 = query.getOrDefault("uploadType")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "uploadType", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  var valid_589065 = query.getOrDefault("updateMask")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "updateMask", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589067: Call_BigtableadminProjectsInstancesAppProfilesPatch_589049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an app profile within an instance.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_BigtableadminProjectsInstancesAppProfilesPatch_589049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; ignoreWarnings: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesPatch
  ## Updates an app profile within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  ##   alt: string
  ##      : Data format for response.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when updating the app profile.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  var path_589069 = newJObject()
  var query_589070 = newJObject()
  var body_589071 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(path_589069, "name", newJString(name))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  add(query_589070, "updateMask", newJString(updateMask))
  result = call_589068.call(path_589069, query_589070, nil, nil, body_589071)

var bigtableadminProjectsInstancesAppProfilesPatch* = Call_BigtableadminProjectsInstancesAppProfilesPatch_589049(
    name: "bigtableadminProjectsInstancesAppProfilesPatch",
    meth: HttpMethod.HttpPatch, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesAppProfilesPatch_589050,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesPatch_589051,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsDelete_589029 = ref object of OpenApiRestCall_588450
proc url_BigtableadminOperationsDelete_589031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsDelete_589030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589032 = path.getOrDefault("name")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "name", valid_589032
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when deleting the app profile.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("ignoreWarnings")
  valid_589037 = validateParameter(valid_589037, JBool, required = false, default = nil)
  if valid_589037 != nil:
    section.add "ignoreWarnings", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("callback")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "callback", valid_589039
  var valid_589040 = query.getOrDefault("access_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "access_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("$.xgafv")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("1"))
  if valid_589043 != nil:
    section.add "$.xgafv", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589045: Call_BigtableadminOperationsDelete_589029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_BigtableadminOperationsDelete_589029; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; ignoreWarnings: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when deleting the app profile.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589047 = newJObject()
  var query_589048 = newJObject()
  add(query_589048, "upload_protocol", newJString(uploadProtocol))
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(path_589047, "name", newJString(name))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "callback", newJString(callback))
  add(query_589048, "access_token", newJString(accessToken))
  add(query_589048, "uploadType", newJString(uploadType))
  add(query_589048, "key", newJString(key))
  add(query_589048, "$.xgafv", newJString(Xgafv))
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589046.call(path_589047, query_589048, nil, nil, nil)

var bigtableadminOperationsDelete* = Call_BigtableadminOperationsDelete_589029(
    name: "bigtableadminOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsDelete_589030, base: "/",
    url: url_BigtableadminOperationsDelete_589031, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsLocationsList_589072 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsLocationsList_589074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsLocationsList_589073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589075 = path.getOrDefault("name")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "name", valid_589075
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589076 = query.getOrDefault("upload_protocol")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "upload_protocol", valid_589076
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("pageToken")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "pageToken", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("uploadType")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "uploadType", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("$.xgafv")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("1"))
  if valid_589086 != nil:
    section.add "$.xgafv", valid_589086
  var valid_589087 = query.getOrDefault("pageSize")
  valid_589087 = validateParameter(valid_589087, JInt, required = false, default = nil)
  if valid_589087 != nil:
    section.add "pageSize", valid_589087
  var valid_589088 = query.getOrDefault("prettyPrint")
  valid_589088 = validateParameter(valid_589088, JBool, required = false,
                                 default = newJBool(true))
  if valid_589088 != nil:
    section.add "prettyPrint", valid_589088
  var valid_589089 = query.getOrDefault("filter")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "filter", valid_589089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589090: Call_BigtableadminProjectsLocationsList_589072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_BigtableadminProjectsLocationsList_589072;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigtableadminProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  add(query_589093, "upload_protocol", newJString(uploadProtocol))
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "pageToken", newJString(pageToken))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(path_589092, "name", newJString(name))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "callback", newJString(callback))
  add(query_589093, "access_token", newJString(accessToken))
  add(query_589093, "uploadType", newJString(uploadType))
  add(query_589093, "key", newJString(key))
  add(query_589093, "$.xgafv", newJString(Xgafv))
  add(query_589093, "pageSize", newJInt(pageSize))
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  add(query_589093, "filter", newJString(filter))
  result = call_589091.call(path_589092, query_589093, nil, nil, nil)

var bigtableadminProjectsLocationsList* = Call_BigtableadminProjectsLocationsList_589072(
    name: "bigtableadminProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}/locations",
    validator: validate_BigtableadminProjectsLocationsList_589073, base: "/",
    url: url_BigtableadminProjectsLocationsList_589074, schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsProjectsOperationsList_589094 = ref object of OpenApiRestCall_588450
proc url_BigtableadminOperationsProjectsOperationsList_589096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsProjectsOperationsList_589095(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589097 = path.getOrDefault("name")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "name", valid_589097
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589098 = query.getOrDefault("upload_protocol")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "upload_protocol", valid_589098
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("pageToken")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "pageToken", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("callback")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "callback", valid_589104
  var valid_589105 = query.getOrDefault("access_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "access_token", valid_589105
  var valid_589106 = query.getOrDefault("uploadType")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "uploadType", valid_589106
  var valid_589107 = query.getOrDefault("key")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "key", valid_589107
  var valid_589108 = query.getOrDefault("$.xgafv")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("1"))
  if valid_589108 != nil:
    section.add "$.xgafv", valid_589108
  var valid_589109 = query.getOrDefault("pageSize")
  valid_589109 = validateParameter(valid_589109, JInt, required = false, default = nil)
  if valid_589109 != nil:
    section.add "pageSize", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  var valid_589111 = query.getOrDefault("filter")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "filter", valid_589111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589112: Call_BigtableadminOperationsProjectsOperationsList_589094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589112.validator(path, query, header, formData, body)
  let scheme = call_589112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589112.url(scheme.get, call_589112.host, call_589112.base,
                         call_589112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589112, url, valid)

proc call*(call_589113: Call_BigtableadminOperationsProjectsOperationsList_589094;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigtableadminOperationsProjectsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589114 = newJObject()
  var query_589115 = newJObject()
  add(query_589115, "upload_protocol", newJString(uploadProtocol))
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "pageToken", newJString(pageToken))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(path_589114, "name", newJString(name))
  add(query_589115, "alt", newJString(alt))
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "callback", newJString(callback))
  add(query_589115, "access_token", newJString(accessToken))
  add(query_589115, "uploadType", newJString(uploadType))
  add(query_589115, "key", newJString(key))
  add(query_589115, "$.xgafv", newJString(Xgafv))
  add(query_589115, "pageSize", newJInt(pageSize))
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  add(query_589115, "filter", newJString(filter))
  result = call_589113.call(path_589114, query_589115, nil, nil, nil)

var bigtableadminOperationsProjectsOperationsList* = Call_BigtableadminOperationsProjectsOperationsList_589094(
    name: "bigtableadminOperationsProjectsOperationsList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}/operations",
    validator: validate_BigtableadminOperationsProjectsOperationsList_589095,
    base: "/", url: url_BigtableadminOperationsProjectsOperationsList_589096,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsCancel_589116 = ref object of OpenApiRestCall_588450
proc url_BigtableadminOperationsCancel_589118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsCancel_589117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589119 = path.getOrDefault("name")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "name", valid_589119
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589120 = query.getOrDefault("upload_protocol")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "upload_protocol", valid_589120
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("callback")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "callback", valid_589125
  var valid_589126 = query.getOrDefault("access_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "access_token", valid_589126
  var valid_589127 = query.getOrDefault("uploadType")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "uploadType", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("$.xgafv")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("1"))
  if valid_589129 != nil:
    section.add "$.xgafv", valid_589129
  var valid_589130 = query.getOrDefault("prettyPrint")
  valid_589130 = validateParameter(valid_589130, JBool, required = false,
                                 default = newJBool(true))
  if valid_589130 != nil:
    section.add "prettyPrint", valid_589130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589131: Call_BigtableadminOperationsCancel_589116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589131.validator(path, query, header, formData, body)
  let scheme = call_589131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589131.url(scheme.get, call_589131.host, call_589131.base,
                         call_589131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589131, url, valid)

proc call*(call_589132: Call_BigtableadminOperationsCancel_589116; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589133 = newJObject()
  var query_589134 = newJObject()
  add(query_589134, "upload_protocol", newJString(uploadProtocol))
  add(query_589134, "fields", newJString(fields))
  add(query_589134, "quotaUser", newJString(quotaUser))
  add(path_589133, "name", newJString(name))
  add(query_589134, "alt", newJString(alt))
  add(query_589134, "oauth_token", newJString(oauthToken))
  add(query_589134, "callback", newJString(callback))
  add(query_589134, "access_token", newJString(accessToken))
  add(query_589134, "uploadType", newJString(uploadType))
  add(query_589134, "key", newJString(key))
  add(query_589134, "$.xgafv", newJString(Xgafv))
  add(query_589134, "prettyPrint", newJBool(prettyPrint))
  result = call_589132.call(path_589133, query_589134, nil, nil, nil)

var bigtableadminOperationsCancel* = Call_BigtableadminOperationsCancel_589116(
    name: "bigtableadminOperationsCancel", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_BigtableadminOperationsCancel_589117, base: "/",
    url: url_BigtableadminOperationsCancel_589118, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCheckConsistency_589135 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesCheckConsistency_589137(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":checkConsistency")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCheckConsistency_589136(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589138 = path.getOrDefault("name")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "name", valid_589138
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589139 = query.getOrDefault("upload_protocol")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "upload_protocol", valid_589139
  var valid_589140 = query.getOrDefault("fields")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fields", valid_589140
  var valid_589141 = query.getOrDefault("quotaUser")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "quotaUser", valid_589141
  var valid_589142 = query.getOrDefault("alt")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("json"))
  if valid_589142 != nil:
    section.add "alt", valid_589142
  var valid_589143 = query.getOrDefault("oauth_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "oauth_token", valid_589143
  var valid_589144 = query.getOrDefault("callback")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "callback", valid_589144
  var valid_589145 = query.getOrDefault("access_token")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "access_token", valid_589145
  var valid_589146 = query.getOrDefault("uploadType")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "uploadType", valid_589146
  var valid_589147 = query.getOrDefault("key")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "key", valid_589147
  var valid_589148 = query.getOrDefault("$.xgafv")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = newJString("1"))
  if valid_589148 != nil:
    section.add "$.xgafv", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589151: Call_BigtableadminProjectsInstancesTablesCheckConsistency_589135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_BigtableadminProjectsInstancesTablesCheckConsistency_589135;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesCheckConsistency
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589153 = newJObject()
  var query_589154 = newJObject()
  var body_589155 = newJObject()
  add(query_589154, "upload_protocol", newJString(uploadProtocol))
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(path_589153, "name", newJString(name))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "oauth_token", newJString(oauthToken))
  add(query_589154, "callback", newJString(callback))
  add(query_589154, "access_token", newJString(accessToken))
  add(query_589154, "uploadType", newJString(uploadType))
  add(query_589154, "key", newJString(key))
  add(query_589154, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589155 = body
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(path_589153, query_589154, nil, nil, body_589155)

var bigtableadminProjectsInstancesTablesCheckConsistency* = Call_BigtableadminProjectsInstancesTablesCheckConsistency_589135(
    name: "bigtableadminProjectsInstancesTablesCheckConsistency",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:checkConsistency",
    validator: validate_BigtableadminProjectsInstancesTablesCheckConsistency_589136,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCheckConsistency_589137,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesDropRowRange_589156 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesDropRowRange_589158(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":dropRowRange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesDropRowRange_589157(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589159 = path.getOrDefault("name")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "name", valid_589159
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589160 = query.getOrDefault("upload_protocol")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "upload_protocol", valid_589160
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("callback")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "callback", valid_589165
  var valid_589166 = query.getOrDefault("access_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "access_token", valid_589166
  var valid_589167 = query.getOrDefault("uploadType")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "uploadType", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("$.xgafv")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("1"))
  if valid_589169 != nil:
    section.add "$.xgafv", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589172: Call_BigtableadminProjectsInstancesTablesDropRowRange_589156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  let valid = call_589172.validator(path, query, header, formData, body)
  let scheme = call_589172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589172.url(scheme.get, call_589172.host, call_589172.base,
                         call_589172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589172, url, valid)

proc call*(call_589173: Call_BigtableadminProjectsInstancesTablesDropRowRange_589156;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesDropRowRange
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589174 = newJObject()
  var query_589175 = newJObject()
  var body_589176 = newJObject()
  add(query_589175, "upload_protocol", newJString(uploadProtocol))
  add(query_589175, "fields", newJString(fields))
  add(query_589175, "quotaUser", newJString(quotaUser))
  add(path_589174, "name", newJString(name))
  add(query_589175, "alt", newJString(alt))
  add(query_589175, "oauth_token", newJString(oauthToken))
  add(query_589175, "callback", newJString(callback))
  add(query_589175, "access_token", newJString(accessToken))
  add(query_589175, "uploadType", newJString(uploadType))
  add(query_589175, "key", newJString(key))
  add(query_589175, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589176 = body
  add(query_589175, "prettyPrint", newJBool(prettyPrint))
  result = call_589173.call(path_589174, query_589175, nil, nil, body_589176)

var bigtableadminProjectsInstancesTablesDropRowRange* = Call_BigtableadminProjectsInstancesTablesDropRowRange_589156(
    name: "bigtableadminProjectsInstancesTablesDropRowRange",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:dropRowRange",
    validator: validate_BigtableadminProjectsInstancesTablesDropRowRange_589157,
    base: "/", url: url_BigtableadminProjectsInstancesTablesDropRowRange_589158,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589177 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589179(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":generateConsistencyToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589178(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589180 = path.getOrDefault("name")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "name", valid_589180
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589181 = query.getOrDefault("upload_protocol")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "upload_protocol", valid_589181
  var valid_589182 = query.getOrDefault("fields")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "fields", valid_589182
  var valid_589183 = query.getOrDefault("quotaUser")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "quotaUser", valid_589183
  var valid_589184 = query.getOrDefault("alt")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("json"))
  if valid_589184 != nil:
    section.add "alt", valid_589184
  var valid_589185 = query.getOrDefault("oauth_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "oauth_token", valid_589185
  var valid_589186 = query.getOrDefault("callback")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "callback", valid_589186
  var valid_589187 = query.getOrDefault("access_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "access_token", valid_589187
  var valid_589188 = query.getOrDefault("uploadType")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "uploadType", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("$.xgafv")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("1"))
  if valid_589190 != nil:
    section.add "$.xgafv", valid_589190
  var valid_589191 = query.getOrDefault("prettyPrint")
  valid_589191 = validateParameter(valid_589191, JBool, required = false,
                                 default = newJBool(true))
  if valid_589191 != nil:
    section.add "prettyPrint", valid_589191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589193: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589177;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesGenerateConsistencyToken
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  var body_589197 = newJObject()
  add(query_589196, "upload_protocol", newJString(uploadProtocol))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(path_589195, "name", newJString(name))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "callback", newJString(callback))
  add(query_589196, "access_token", newJString(accessToken))
  add(query_589196, "uploadType", newJString(uploadType))
  add(query_589196, "key", newJString(key))
  add(query_589196, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589197 = body
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  result = call_589194.call(path_589195, query_589196, nil, nil, body_589197)

var bigtableadminProjectsInstancesTablesGenerateConsistencyToken* = Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589177(
    name: "bigtableadminProjectsInstancesTablesGenerateConsistencyToken",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:generateConsistencyToken", validator: validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589178,
    base: "/",
    url: url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_589179,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589198 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589200(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":modifyColumnFamilies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589199(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589201 = path.getOrDefault("name")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "name", valid_589201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589202 = query.getOrDefault("upload_protocol")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "upload_protocol", valid_589202
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("callback")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "callback", valid_589207
  var valid_589208 = query.getOrDefault("access_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "access_token", valid_589208
  var valid_589209 = query.getOrDefault("uploadType")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "uploadType", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("$.xgafv")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("1"))
  if valid_589211 != nil:
    section.add "$.xgafv", valid_589211
  var valid_589212 = query.getOrDefault("prettyPrint")
  valid_589212 = validateParameter(valid_589212, JBool, required = false,
                                 default = newJBool(true))
  if valid_589212 != nil:
    section.add "prettyPrint", valid_589212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589214: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  let valid = call_589214.validator(path, query, header, formData, body)
  let scheme = call_589214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589214.url(scheme.get, call_589214.host, call_589214.base,
                         call_589214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589214, url, valid)

proc call*(call_589215: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589198;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesModifyColumnFamilies
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589216 = newJObject()
  var query_589217 = newJObject()
  var body_589218 = newJObject()
  add(query_589217, "upload_protocol", newJString(uploadProtocol))
  add(query_589217, "fields", newJString(fields))
  add(query_589217, "quotaUser", newJString(quotaUser))
  add(path_589216, "name", newJString(name))
  add(query_589217, "alt", newJString(alt))
  add(query_589217, "oauth_token", newJString(oauthToken))
  add(query_589217, "callback", newJString(callback))
  add(query_589217, "access_token", newJString(accessToken))
  add(query_589217, "uploadType", newJString(uploadType))
  add(query_589217, "key", newJString(key))
  add(query_589217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589218 = body
  add(query_589217, "prettyPrint", newJBool(prettyPrint))
  result = call_589215.call(path_589216, query_589217, nil, nil, body_589218)

var bigtableadminProjectsInstancesTablesModifyColumnFamilies* = Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589198(
    name: "bigtableadminProjectsInstancesTablesModifyColumnFamilies",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:modifyColumnFamilies", validator: validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589199,
    base: "/", url: url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_589200,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesCreate_589240 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesAppProfilesCreate_589242(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesCreate_589241(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589243 = path.getOrDefault("parent")
  valid_589243 = validateParameter(valid_589243, JString, required = true,
                                 default = nil)
  if valid_589243 != nil:
    section.add "parent", valid_589243
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when creating the app profile.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appProfileId: JString
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589244 = query.getOrDefault("upload_protocol")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "upload_protocol", valid_589244
  var valid_589245 = query.getOrDefault("fields")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "fields", valid_589245
  var valid_589246 = query.getOrDefault("quotaUser")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "quotaUser", valid_589246
  var valid_589247 = query.getOrDefault("alt")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("json"))
  if valid_589247 != nil:
    section.add "alt", valid_589247
  var valid_589248 = query.getOrDefault("ignoreWarnings")
  valid_589248 = validateParameter(valid_589248, JBool, required = false, default = nil)
  if valid_589248 != nil:
    section.add "ignoreWarnings", valid_589248
  var valid_589249 = query.getOrDefault("oauth_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "oauth_token", valid_589249
  var valid_589250 = query.getOrDefault("callback")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "callback", valid_589250
  var valid_589251 = query.getOrDefault("access_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "access_token", valid_589251
  var valid_589252 = query.getOrDefault("uploadType")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "uploadType", valid_589252
  var valid_589253 = query.getOrDefault("key")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "key", valid_589253
  var valid_589254 = query.getOrDefault("appProfileId")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "appProfileId", valid_589254
  var valid_589255 = query.getOrDefault("$.xgafv")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("1"))
  if valid_589255 != nil:
    section.add "$.xgafv", valid_589255
  var valid_589256 = query.getOrDefault("prettyPrint")
  valid_589256 = validateParameter(valid_589256, JBool, required = false,
                                 default = newJBool(true))
  if valid_589256 != nil:
    section.add "prettyPrint", valid_589256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589258: Call_BigtableadminProjectsInstancesAppProfilesCreate_589240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an app profile within an instance.
  ## 
  let valid = call_589258.validator(path, query, header, formData, body)
  let scheme = call_589258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589258.url(scheme.get, call_589258.host, call_589258.base,
                         call_589258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589258, url, valid)

proc call*(call_589259: Call_BigtableadminProjectsInstancesAppProfilesCreate_589240;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; ignoreWarnings: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; appProfileId: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesCreate
  ## Creates an app profile within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when creating the app profile.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appProfileId: string
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589260 = newJObject()
  var query_589261 = newJObject()
  var body_589262 = newJObject()
  add(query_589261, "upload_protocol", newJString(uploadProtocol))
  add(query_589261, "fields", newJString(fields))
  add(query_589261, "quotaUser", newJString(quotaUser))
  add(query_589261, "alt", newJString(alt))
  add(query_589261, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_589261, "oauth_token", newJString(oauthToken))
  add(query_589261, "callback", newJString(callback))
  add(query_589261, "access_token", newJString(accessToken))
  add(query_589261, "uploadType", newJString(uploadType))
  add(path_589260, "parent", newJString(parent))
  add(query_589261, "key", newJString(key))
  add(query_589261, "appProfileId", newJString(appProfileId))
  add(query_589261, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589262 = body
  add(query_589261, "prettyPrint", newJBool(prettyPrint))
  result = call_589259.call(path_589260, query_589261, nil, nil, body_589262)

var bigtableadminProjectsInstancesAppProfilesCreate* = Call_BigtableadminProjectsInstancesAppProfilesCreate_589240(
    name: "bigtableadminProjectsInstancesAppProfilesCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesCreate_589241,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesCreate_589242,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesList_589219 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesAppProfilesList_589221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesList_589220(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists information about app profiles in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589222 = path.getOrDefault("parent")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "parent", valid_589222
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589223 = query.getOrDefault("upload_protocol")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "upload_protocol", valid_589223
  var valid_589224 = query.getOrDefault("fields")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "fields", valid_589224
  var valid_589225 = query.getOrDefault("pageToken")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "pageToken", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("alt")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("json"))
  if valid_589227 != nil:
    section.add "alt", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("callback")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "callback", valid_589229
  var valid_589230 = query.getOrDefault("access_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "access_token", valid_589230
  var valid_589231 = query.getOrDefault("uploadType")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "uploadType", valid_589231
  var valid_589232 = query.getOrDefault("key")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "key", valid_589232
  var valid_589233 = query.getOrDefault("$.xgafv")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("1"))
  if valid_589233 != nil:
    section.add "$.xgafv", valid_589233
  var valid_589234 = query.getOrDefault("pageSize")
  valid_589234 = validateParameter(valid_589234, JInt, required = false, default = nil)
  if valid_589234 != nil:
    section.add "pageSize", valid_589234
  var valid_589235 = query.getOrDefault("prettyPrint")
  valid_589235 = validateParameter(valid_589235, JBool, required = false,
                                 default = newJBool(true))
  if valid_589235 != nil:
    section.add "prettyPrint", valid_589235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589236: Call_BigtableadminProjectsInstancesAppProfilesList_589219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about app profiles in an instance.
  ## 
  let valid = call_589236.validator(path, query, header, formData, body)
  let scheme = call_589236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589236.url(scheme.get, call_589236.host, call_589236.base,
                         call_589236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589236, url, valid)

proc call*(call_589237: Call_BigtableadminProjectsInstancesAppProfilesList_589219;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesList
  ## Lists information about app profiles in an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589238 = newJObject()
  var query_589239 = newJObject()
  add(query_589239, "upload_protocol", newJString(uploadProtocol))
  add(query_589239, "fields", newJString(fields))
  add(query_589239, "pageToken", newJString(pageToken))
  add(query_589239, "quotaUser", newJString(quotaUser))
  add(query_589239, "alt", newJString(alt))
  add(query_589239, "oauth_token", newJString(oauthToken))
  add(query_589239, "callback", newJString(callback))
  add(query_589239, "access_token", newJString(accessToken))
  add(query_589239, "uploadType", newJString(uploadType))
  add(path_589238, "parent", newJString(parent))
  add(query_589239, "key", newJString(key))
  add(query_589239, "$.xgafv", newJString(Xgafv))
  add(query_589239, "pageSize", newJInt(pageSize))
  add(query_589239, "prettyPrint", newJBool(prettyPrint))
  result = call_589237.call(path_589238, query_589239, nil, nil, nil)

var bigtableadminProjectsInstancesAppProfilesList* = Call_BigtableadminProjectsInstancesAppProfilesList_589219(
    name: "bigtableadminProjectsInstancesAppProfilesList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesList_589220,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesList_589221,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersCreate_589283 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesClustersCreate_589285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersCreate_589284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589286 = path.getOrDefault("parent")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "parent", valid_589286
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  section = newJObject()
  var valid_589287 = query.getOrDefault("upload_protocol")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "upload_protocol", valid_589287
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("callback")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "callback", valid_589292
  var valid_589293 = query.getOrDefault("access_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "access_token", valid_589293
  var valid_589294 = query.getOrDefault("uploadType")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "uploadType", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("$.xgafv")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("1"))
  if valid_589296 != nil:
    section.add "$.xgafv", valid_589296
  var valid_589297 = query.getOrDefault("prettyPrint")
  valid_589297 = validateParameter(valid_589297, JBool, required = false,
                                 default = newJBool(true))
  if valid_589297 != nil:
    section.add "prettyPrint", valid_589297
  var valid_589298 = query.getOrDefault("clusterId")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "clusterId", valid_589298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589300: Call_BigtableadminProjectsInstancesClustersCreate_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster within an instance.
  ## 
  let valid = call_589300.validator(path, query, header, formData, body)
  let scheme = call_589300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589300.url(scheme.get, call_589300.host, call_589300.base,
                         call_589300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589300, url, valid)

proc call*(call_589301: Call_BigtableadminProjectsInstancesClustersCreate_589283;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## bigtableadminProjectsInstancesClustersCreate
  ## Creates a cluster within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  var path_589302 = newJObject()
  var query_589303 = newJObject()
  var body_589304 = newJObject()
  add(query_589303, "upload_protocol", newJString(uploadProtocol))
  add(query_589303, "fields", newJString(fields))
  add(query_589303, "quotaUser", newJString(quotaUser))
  add(query_589303, "alt", newJString(alt))
  add(query_589303, "oauth_token", newJString(oauthToken))
  add(query_589303, "callback", newJString(callback))
  add(query_589303, "access_token", newJString(accessToken))
  add(query_589303, "uploadType", newJString(uploadType))
  add(path_589302, "parent", newJString(parent))
  add(query_589303, "key", newJString(key))
  add(query_589303, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589304 = body
  add(query_589303, "prettyPrint", newJBool(prettyPrint))
  add(query_589303, "clusterId", newJString(clusterId))
  result = call_589301.call(path_589302, query_589303, nil, nil, body_589304)

var bigtableadminProjectsInstancesClustersCreate* = Call_BigtableadminProjectsInstancesClustersCreate_589283(
    name: "bigtableadminProjectsInstancesClustersCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersCreate_589284,
    base: "/", url: url_BigtableadminProjectsInstancesClustersCreate_589285,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersList_589263 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesClustersList_589265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersList_589264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about clusters in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589266 = path.getOrDefault("parent")
  valid_589266 = validateParameter(valid_589266, JString, required = true,
                                 default = nil)
  if valid_589266 != nil:
    section.add "parent", valid_589266
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589267 = query.getOrDefault("upload_protocol")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "upload_protocol", valid_589267
  var valid_589268 = query.getOrDefault("fields")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "fields", valid_589268
  var valid_589269 = query.getOrDefault("pageToken")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "pageToken", valid_589269
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("callback")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "callback", valid_589273
  var valid_589274 = query.getOrDefault("access_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "access_token", valid_589274
  var valid_589275 = query.getOrDefault("uploadType")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "uploadType", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("$.xgafv")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("1"))
  if valid_589277 != nil:
    section.add "$.xgafv", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_BigtableadminProjectsInstancesClustersList_589263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about clusters in an instance.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_BigtableadminProjectsInstancesClustersList_589263;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesClustersList
  ## Lists information about clusters in an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(query_589282, "upload_protocol", newJString(uploadProtocol))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "pageToken", newJString(pageToken))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(query_589282, "callback", newJString(callback))
  add(query_589282, "access_token", newJString(accessToken))
  add(query_589282, "uploadType", newJString(uploadType))
  add(path_589281, "parent", newJString(parent))
  add(query_589282, "key", newJString(key))
  add(query_589282, "$.xgafv", newJString(Xgafv))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var bigtableadminProjectsInstancesClustersList* = Call_BigtableadminProjectsInstancesClustersList_589263(
    name: "bigtableadminProjectsInstancesClustersList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersList_589264,
    base: "/", url: url_BigtableadminProjectsInstancesClustersList_589265,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesCreate_589325 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesCreate_589327(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesCreate_589326(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an instance within a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589328 = path.getOrDefault("parent")
  valid_589328 = validateParameter(valid_589328, JString, required = true,
                                 default = nil)
  if valid_589328 != nil:
    section.add "parent", valid_589328
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589329 = query.getOrDefault("upload_protocol")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "upload_protocol", valid_589329
  var valid_589330 = query.getOrDefault("fields")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "fields", valid_589330
  var valid_589331 = query.getOrDefault("quotaUser")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "quotaUser", valid_589331
  var valid_589332 = query.getOrDefault("alt")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = newJString("json"))
  if valid_589332 != nil:
    section.add "alt", valid_589332
  var valid_589333 = query.getOrDefault("oauth_token")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "oauth_token", valid_589333
  var valid_589334 = query.getOrDefault("callback")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "callback", valid_589334
  var valid_589335 = query.getOrDefault("access_token")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "access_token", valid_589335
  var valid_589336 = query.getOrDefault("uploadType")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "uploadType", valid_589336
  var valid_589337 = query.getOrDefault("key")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "key", valid_589337
  var valid_589338 = query.getOrDefault("$.xgafv")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = newJString("1"))
  if valid_589338 != nil:
    section.add "$.xgafv", valid_589338
  var valid_589339 = query.getOrDefault("prettyPrint")
  valid_589339 = validateParameter(valid_589339, JBool, required = false,
                                 default = newJBool(true))
  if valid_589339 != nil:
    section.add "prettyPrint", valid_589339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589341: Call_BigtableadminProjectsInstancesCreate_589325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an instance within a project.
  ## 
  let valid = call_589341.validator(path, query, header, formData, body)
  let scheme = call_589341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589341.url(scheme.get, call_589341.host, call_589341.base,
                         call_589341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589341, url, valid)

proc call*(call_589342: Call_BigtableadminProjectsInstancesCreate_589325;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesCreate
  ## Create an instance within a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589343 = newJObject()
  var query_589344 = newJObject()
  var body_589345 = newJObject()
  add(query_589344, "upload_protocol", newJString(uploadProtocol))
  add(query_589344, "fields", newJString(fields))
  add(query_589344, "quotaUser", newJString(quotaUser))
  add(query_589344, "alt", newJString(alt))
  add(query_589344, "oauth_token", newJString(oauthToken))
  add(query_589344, "callback", newJString(callback))
  add(query_589344, "access_token", newJString(accessToken))
  add(query_589344, "uploadType", newJString(uploadType))
  add(path_589343, "parent", newJString(parent))
  add(query_589344, "key", newJString(key))
  add(query_589344, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589345 = body
  add(query_589344, "prettyPrint", newJBool(prettyPrint))
  result = call_589342.call(path_589343, query_589344, nil, nil, body_589345)

var bigtableadminProjectsInstancesCreate* = Call_BigtableadminProjectsInstancesCreate_589325(
    name: "bigtableadminProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesCreate_589326, base: "/",
    url: url_BigtableadminProjectsInstancesCreate_589327, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesList_589305 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesList_589307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesList_589306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about instances in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589308 = path.getOrDefault("parent")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "parent", valid_589308
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589309 = query.getOrDefault("upload_protocol")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "upload_protocol", valid_589309
  var valid_589310 = query.getOrDefault("fields")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "fields", valid_589310
  var valid_589311 = query.getOrDefault("pageToken")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "pageToken", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("callback")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "callback", valid_589315
  var valid_589316 = query.getOrDefault("access_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "access_token", valid_589316
  var valid_589317 = query.getOrDefault("uploadType")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "uploadType", valid_589317
  var valid_589318 = query.getOrDefault("key")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "key", valid_589318
  var valid_589319 = query.getOrDefault("$.xgafv")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("1"))
  if valid_589319 != nil:
    section.add "$.xgafv", valid_589319
  var valid_589320 = query.getOrDefault("prettyPrint")
  valid_589320 = validateParameter(valid_589320, JBool, required = false,
                                 default = newJBool(true))
  if valid_589320 != nil:
    section.add "prettyPrint", valid_589320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589321: Call_BigtableadminProjectsInstancesList_589305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about instances in a project.
  ## 
  let valid = call_589321.validator(path, query, header, formData, body)
  let scheme = call_589321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589321.url(scheme.get, call_589321.host, call_589321.base,
                         call_589321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589321, url, valid)

proc call*(call_589322: Call_BigtableadminProjectsInstancesList_589305;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesList
  ## Lists information about instances in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589323 = newJObject()
  var query_589324 = newJObject()
  add(query_589324, "upload_protocol", newJString(uploadProtocol))
  add(query_589324, "fields", newJString(fields))
  add(query_589324, "pageToken", newJString(pageToken))
  add(query_589324, "quotaUser", newJString(quotaUser))
  add(query_589324, "alt", newJString(alt))
  add(query_589324, "oauth_token", newJString(oauthToken))
  add(query_589324, "callback", newJString(callback))
  add(query_589324, "access_token", newJString(accessToken))
  add(query_589324, "uploadType", newJString(uploadType))
  add(path_589323, "parent", newJString(parent))
  add(query_589324, "key", newJString(key))
  add(query_589324, "$.xgafv", newJString(Xgafv))
  add(query_589324, "prettyPrint", newJBool(prettyPrint))
  result = call_589322.call(path_589323, query_589324, nil, nil, nil)

var bigtableadminProjectsInstancesList* = Call_BigtableadminProjectsInstancesList_589305(
    name: "bigtableadminProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesList_589306, base: "/",
    url: url_BigtableadminProjectsInstancesList_589307, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCreate_589368 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesCreate_589370(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCreate_589369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589371 = path.getOrDefault("parent")
  valid_589371 = validateParameter(valid_589371, JString, required = true,
                                 default = nil)
  if valid_589371 != nil:
    section.add "parent", valid_589371
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589372 = query.getOrDefault("upload_protocol")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "upload_protocol", valid_589372
  var valid_589373 = query.getOrDefault("fields")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "fields", valid_589373
  var valid_589374 = query.getOrDefault("quotaUser")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "quotaUser", valid_589374
  var valid_589375 = query.getOrDefault("alt")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("json"))
  if valid_589375 != nil:
    section.add "alt", valid_589375
  var valid_589376 = query.getOrDefault("oauth_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "oauth_token", valid_589376
  var valid_589377 = query.getOrDefault("callback")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "callback", valid_589377
  var valid_589378 = query.getOrDefault("access_token")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "access_token", valid_589378
  var valid_589379 = query.getOrDefault("uploadType")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "uploadType", valid_589379
  var valid_589380 = query.getOrDefault("key")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "key", valid_589380
  var valid_589381 = query.getOrDefault("$.xgafv")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = newJString("1"))
  if valid_589381 != nil:
    section.add "$.xgafv", valid_589381
  var valid_589382 = query.getOrDefault("prettyPrint")
  valid_589382 = validateParameter(valid_589382, JBool, required = false,
                                 default = newJBool(true))
  if valid_589382 != nil:
    section.add "prettyPrint", valid_589382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589384: Call_BigtableadminProjectsInstancesTablesCreate_589368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  let valid = call_589384.validator(path, query, header, formData, body)
  let scheme = call_589384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589384.url(scheme.get, call_589384.host, call_589384.base,
                         call_589384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589384, url, valid)

proc call*(call_589385: Call_BigtableadminProjectsInstancesTablesCreate_589368;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesCreate
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589386 = newJObject()
  var query_589387 = newJObject()
  var body_589388 = newJObject()
  add(query_589387, "upload_protocol", newJString(uploadProtocol))
  add(query_589387, "fields", newJString(fields))
  add(query_589387, "quotaUser", newJString(quotaUser))
  add(query_589387, "alt", newJString(alt))
  add(query_589387, "oauth_token", newJString(oauthToken))
  add(query_589387, "callback", newJString(callback))
  add(query_589387, "access_token", newJString(accessToken))
  add(query_589387, "uploadType", newJString(uploadType))
  add(path_589386, "parent", newJString(parent))
  add(query_589387, "key", newJString(key))
  add(query_589387, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589388 = body
  add(query_589387, "prettyPrint", newJBool(prettyPrint))
  result = call_589385.call(path_589386, query_589387, nil, nil, body_589388)

var bigtableadminProjectsInstancesTablesCreate* = Call_BigtableadminProjectsInstancesTablesCreate_589368(
    name: "bigtableadminProjectsInstancesTablesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesCreate_589369,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCreate_589370,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesList_589346 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTablesList_589348(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesList_589347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all tables served from a specified instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589349 = path.getOrDefault("parent")
  valid_589349 = validateParameter(valid_589349, JString, required = true,
                                 default = nil)
  if valid_589349 != nil:
    section.add "parent", valid_589349
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589350 = query.getOrDefault("upload_protocol")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "upload_protocol", valid_589350
  var valid_589351 = query.getOrDefault("fields")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "fields", valid_589351
  var valid_589352 = query.getOrDefault("pageToken")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "pageToken", valid_589352
  var valid_589353 = query.getOrDefault("quotaUser")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "quotaUser", valid_589353
  var valid_589354 = query.getOrDefault("view")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589354 != nil:
    section.add "view", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("callback")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "callback", valid_589357
  var valid_589358 = query.getOrDefault("access_token")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "access_token", valid_589358
  var valid_589359 = query.getOrDefault("uploadType")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "uploadType", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("$.xgafv")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("1"))
  if valid_589361 != nil:
    section.add "$.xgafv", valid_589361
  var valid_589362 = query.getOrDefault("pageSize")
  valid_589362 = validateParameter(valid_589362, JInt, required = false, default = nil)
  if valid_589362 != nil:
    section.add "pageSize", valid_589362
  var valid_589363 = query.getOrDefault("prettyPrint")
  valid_589363 = validateParameter(valid_589363, JBool, required = false,
                                 default = newJBool(true))
  if valid_589363 != nil:
    section.add "prettyPrint", valid_589363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589364: Call_BigtableadminProjectsInstancesTablesList_589346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all tables served from a specified instance.
  ## 
  let valid = call_589364.validator(path, query, header, formData, body)
  let scheme = call_589364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589364.url(scheme.get, call_589364.host, call_589364.base,
                         call_589364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589364, url, valid)

proc call*(call_589365: Call_BigtableadminProjectsInstancesTablesList_589346;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesList
  ## Lists all tables served from a specified instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589366 = newJObject()
  var query_589367 = newJObject()
  add(query_589367, "upload_protocol", newJString(uploadProtocol))
  add(query_589367, "fields", newJString(fields))
  add(query_589367, "pageToken", newJString(pageToken))
  add(query_589367, "quotaUser", newJString(quotaUser))
  add(query_589367, "view", newJString(view))
  add(query_589367, "alt", newJString(alt))
  add(query_589367, "oauth_token", newJString(oauthToken))
  add(query_589367, "callback", newJString(callback))
  add(query_589367, "access_token", newJString(accessToken))
  add(query_589367, "uploadType", newJString(uploadType))
  add(path_589366, "parent", newJString(parent))
  add(query_589367, "key", newJString(key))
  add(query_589367, "$.xgafv", newJString(Xgafv))
  add(query_589367, "pageSize", newJInt(pageSize))
  add(query_589367, "prettyPrint", newJBool(prettyPrint))
  result = call_589365.call(path_589366, query_589367, nil, nil, nil)

var bigtableadminProjectsInstancesTablesList* = Call_BigtableadminProjectsInstancesTablesList_589346(
    name: "bigtableadminProjectsInstancesTablesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesList_589347,
    base: "/", url: url_BigtableadminProjectsInstancesTablesList_589348,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesGetIamPolicy_589389 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesGetIamPolicy_589391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesGetIamPolicy_589390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589392 = path.getOrDefault("resource")
  valid_589392 = validateParameter(valid_589392, JString, required = true,
                                 default = nil)
  if valid_589392 != nil:
    section.add "resource", valid_589392
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589393 = query.getOrDefault("upload_protocol")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "upload_protocol", valid_589393
  var valid_589394 = query.getOrDefault("fields")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "fields", valid_589394
  var valid_589395 = query.getOrDefault("quotaUser")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "quotaUser", valid_589395
  var valid_589396 = query.getOrDefault("alt")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = newJString("json"))
  if valid_589396 != nil:
    section.add "alt", valid_589396
  var valid_589397 = query.getOrDefault("oauth_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "oauth_token", valid_589397
  var valid_589398 = query.getOrDefault("callback")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "callback", valid_589398
  var valid_589399 = query.getOrDefault("access_token")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "access_token", valid_589399
  var valid_589400 = query.getOrDefault("uploadType")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "uploadType", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("$.xgafv")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("1"))
  if valid_589402 != nil:
    section.add "$.xgafv", valid_589402
  var valid_589403 = query.getOrDefault("prettyPrint")
  valid_589403 = validateParameter(valid_589403, JBool, required = false,
                                 default = newJBool(true))
  if valid_589403 != nil:
    section.add "prettyPrint", valid_589403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589405: Call_BigtableadminProjectsInstancesGetIamPolicy_589389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  let valid = call_589405.validator(path, query, header, formData, body)
  let scheme = call_589405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589405.url(scheme.get, call_589405.host, call_589405.base,
                         call_589405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589405, url, valid)

proc call*(call_589406: Call_BigtableadminProjectsInstancesGetIamPolicy_589389;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesGetIamPolicy
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589407 = newJObject()
  var query_589408 = newJObject()
  var body_589409 = newJObject()
  add(query_589408, "upload_protocol", newJString(uploadProtocol))
  add(query_589408, "fields", newJString(fields))
  add(query_589408, "quotaUser", newJString(quotaUser))
  add(query_589408, "alt", newJString(alt))
  add(query_589408, "oauth_token", newJString(oauthToken))
  add(query_589408, "callback", newJString(callback))
  add(query_589408, "access_token", newJString(accessToken))
  add(query_589408, "uploadType", newJString(uploadType))
  add(query_589408, "key", newJString(key))
  add(query_589408, "$.xgafv", newJString(Xgafv))
  add(path_589407, "resource", newJString(resource))
  if body != nil:
    body_589409 = body
  add(query_589408, "prettyPrint", newJBool(prettyPrint))
  result = call_589406.call(path_589407, query_589408, nil, nil, body_589409)

var bigtableadminProjectsInstancesGetIamPolicy* = Call_BigtableadminProjectsInstancesGetIamPolicy_589389(
    name: "bigtableadminProjectsInstancesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:getIamPolicy",
    validator: validate_BigtableadminProjectsInstancesGetIamPolicy_589390,
    base: "/", url: url_BigtableadminProjectsInstancesGetIamPolicy_589391,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesSetIamPolicy_589410 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesSetIamPolicy_589412(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesSetIamPolicy_589411(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589413 = path.getOrDefault("resource")
  valid_589413 = validateParameter(valid_589413, JString, required = true,
                                 default = nil)
  if valid_589413 != nil:
    section.add "resource", valid_589413
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589414 = query.getOrDefault("upload_protocol")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "upload_protocol", valid_589414
  var valid_589415 = query.getOrDefault("fields")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "fields", valid_589415
  var valid_589416 = query.getOrDefault("quotaUser")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "quotaUser", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("oauth_token")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "oauth_token", valid_589418
  var valid_589419 = query.getOrDefault("callback")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "callback", valid_589419
  var valid_589420 = query.getOrDefault("access_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "access_token", valid_589420
  var valid_589421 = query.getOrDefault("uploadType")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "uploadType", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("$.xgafv")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = newJString("1"))
  if valid_589423 != nil:
    section.add "$.xgafv", valid_589423
  var valid_589424 = query.getOrDefault("prettyPrint")
  valid_589424 = validateParameter(valid_589424, JBool, required = false,
                                 default = newJBool(true))
  if valid_589424 != nil:
    section.add "prettyPrint", valid_589424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589426: Call_BigtableadminProjectsInstancesSetIamPolicy_589410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589426.validator(path, query, header, formData, body)
  let scheme = call_589426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589426.url(scheme.get, call_589426.host, call_589426.base,
                         call_589426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589426, url, valid)

proc call*(call_589427: Call_BigtableadminProjectsInstancesSetIamPolicy_589410;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesSetIamPolicy
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589428 = newJObject()
  var query_589429 = newJObject()
  var body_589430 = newJObject()
  add(query_589429, "upload_protocol", newJString(uploadProtocol))
  add(query_589429, "fields", newJString(fields))
  add(query_589429, "quotaUser", newJString(quotaUser))
  add(query_589429, "alt", newJString(alt))
  add(query_589429, "oauth_token", newJString(oauthToken))
  add(query_589429, "callback", newJString(callback))
  add(query_589429, "access_token", newJString(accessToken))
  add(query_589429, "uploadType", newJString(uploadType))
  add(query_589429, "key", newJString(key))
  add(query_589429, "$.xgafv", newJString(Xgafv))
  add(path_589428, "resource", newJString(resource))
  if body != nil:
    body_589430 = body
  add(query_589429, "prettyPrint", newJBool(prettyPrint))
  result = call_589427.call(path_589428, query_589429, nil, nil, body_589430)

var bigtableadminProjectsInstancesSetIamPolicy* = Call_BigtableadminProjectsInstancesSetIamPolicy_589410(
    name: "bigtableadminProjectsInstancesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:setIamPolicy",
    validator: validate_BigtableadminProjectsInstancesSetIamPolicy_589411,
    base: "/", url: url_BigtableadminProjectsInstancesSetIamPolicy_589412,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTestIamPermissions_589431 = ref object of OpenApiRestCall_588450
proc url_BigtableadminProjectsInstancesTestIamPermissions_589433(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTestIamPermissions_589432(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589434 = path.getOrDefault("resource")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = nil)
  if valid_589434 != nil:
    section.add "resource", valid_589434
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589435 = query.getOrDefault("upload_protocol")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "upload_protocol", valid_589435
  var valid_589436 = query.getOrDefault("fields")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "fields", valid_589436
  var valid_589437 = query.getOrDefault("quotaUser")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "quotaUser", valid_589437
  var valid_589438 = query.getOrDefault("alt")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = newJString("json"))
  if valid_589438 != nil:
    section.add "alt", valid_589438
  var valid_589439 = query.getOrDefault("oauth_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "oauth_token", valid_589439
  var valid_589440 = query.getOrDefault("callback")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "callback", valid_589440
  var valid_589441 = query.getOrDefault("access_token")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "access_token", valid_589441
  var valid_589442 = query.getOrDefault("uploadType")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "uploadType", valid_589442
  var valid_589443 = query.getOrDefault("key")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "key", valid_589443
  var valid_589444 = query.getOrDefault("$.xgafv")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = newJString("1"))
  if valid_589444 != nil:
    section.add "$.xgafv", valid_589444
  var valid_589445 = query.getOrDefault("prettyPrint")
  valid_589445 = validateParameter(valid_589445, JBool, required = false,
                                 default = newJBool(true))
  if valid_589445 != nil:
    section.add "prettyPrint", valid_589445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589447: Call_BigtableadminProjectsInstancesTestIamPermissions_589431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  let valid = call_589447.validator(path, query, header, formData, body)
  let scheme = call_589447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589447.url(scheme.get, call_589447.host, call_589447.base,
                         call_589447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589447, url, valid)

proc call*(call_589448: Call_BigtableadminProjectsInstancesTestIamPermissions_589431;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTestIamPermissions
  ## Returns permissions that the caller has on the specified instance resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589449 = newJObject()
  var query_589450 = newJObject()
  var body_589451 = newJObject()
  add(query_589450, "upload_protocol", newJString(uploadProtocol))
  add(query_589450, "fields", newJString(fields))
  add(query_589450, "quotaUser", newJString(quotaUser))
  add(query_589450, "alt", newJString(alt))
  add(query_589450, "oauth_token", newJString(oauthToken))
  add(query_589450, "callback", newJString(callback))
  add(query_589450, "access_token", newJString(accessToken))
  add(query_589450, "uploadType", newJString(uploadType))
  add(query_589450, "key", newJString(key))
  add(query_589450, "$.xgafv", newJString(Xgafv))
  add(path_589449, "resource", newJString(resource))
  if body != nil:
    body_589451 = body
  add(query_589450, "prettyPrint", newJBool(prettyPrint))
  result = call_589448.call(path_589449, query_589450, nil, nil, body_589451)

var bigtableadminProjectsInstancesTestIamPermissions* = Call_BigtableadminProjectsInstancesTestIamPermissions_589431(
    name: "bigtableadminProjectsInstancesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_BigtableadminProjectsInstancesTestIamPermissions_589432,
    base: "/", url: url_BigtableadminProjectsInstancesTestIamPermissions_589433,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
