
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Container Analysis
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An implementation of the Grafeas API, which stores, and enables querying and retrieval of critical metadata about all of your software artifacts.
## 
## https://cloud.google.com/container-analysis/api/reference/rest/
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  gcpServiceName = "containeranalysis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProjectsScanConfigsGet_593690 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsScanConfigsGet_593692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsGet_593691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific scan configuration for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the ScanConfig in the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_ContaineranalysisProjectsScanConfigsGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific scan configuration for a project.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_ContaineranalysisProjectsScanConfigsGet_593690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsScanConfigsGet
  ## Gets a specific scan configuration for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the ScanConfig in the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var containeranalysisProjectsScanConfigsGet* = Call_ContaineranalysisProjectsScanConfigsGet_593690(
    name: "containeranalysisProjectsScanConfigsGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsGet_593691, base: "/",
    url: url_ContaineranalysisProjectsScanConfigsGet_593692,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsPatch_593997 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsScanConfigsPatch_593999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsPatch_593998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the scan configuration to a new value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The scan config to update of the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
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
  ##   updateMask: JString
  ##             : The fields to update.
  section = newJObject()
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
  var valid_594012 = query.getOrDefault("updateMask")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "updateMask", valid_594012
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

proc call*(call_594014: Call_ContaineranalysisProjectsScanConfigsPatch_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the scan configuration to a new value.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_ContaineranalysisProjectsScanConfigsPatch_593997;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsPatch
  ## Updates the scan configuration to a new value.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The scan config to update of the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}.
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
  ##   updateMask: string
  ##             : The fields to update.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "upload_protocol", newJString(uploadProtocol))
  add(query_594017, "fields", newJString(fields))
  add(query_594017, "quotaUser", newJString(quotaUser))
  add(path_594016, "name", newJString(name))
  add(query_594017, "alt", newJString(alt))
  add(query_594017, "oauth_token", newJString(oauthToken))
  add(query_594017, "callback", newJString(callback))
  add(query_594017, "access_token", newJString(accessToken))
  add(query_594017, "uploadType", newJString(uploadType))
  add(query_594017, "key", newJString(key))
  add(query_594017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594018 = body
  add(query_594017, "prettyPrint", newJBool(prettyPrint))
  add(query_594017, "updateMask", newJString(updateMask))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var containeranalysisProjectsScanConfigsPatch* = Call_ContaineranalysisProjectsScanConfigsPatch_593997(
    name: "containeranalysisProjectsScanConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsPatch_593998,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsPatch_593999,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesDelete_593978 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesDelete_593980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesDelete_593979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the given `Note` from the system.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ContaineranalysisProjectsNotesDelete_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the given `Note` from the system.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ContaineranalysisProjectsNotesDelete_593978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesDelete
  ## Deletes the given `Note` from the system.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var containeranalysisProjectsNotesDelete* = Call_ContaineranalysisProjectsNotesDelete_593978(
    name: "containeranalysisProjectsNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsNotesDelete_593979, base: "/",
    url: url_ContaineranalysisProjectsNotesDelete_593980, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesCreate_594042 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProvidersNotesCreate_594044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesCreate_594043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594045 = path.getOrDefault("name")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "name", valid_594045
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
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594046 = query.getOrDefault("upload_protocol")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "upload_protocol", valid_594046
  var valid_594047 = query.getOrDefault("fields")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "fields", valid_594047
  var valid_594048 = query.getOrDefault("quotaUser")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "quotaUser", valid_594048
  var valid_594049 = query.getOrDefault("alt")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = newJString("json"))
  if valid_594049 != nil:
    section.add "alt", valid_594049
  var valid_594050 = query.getOrDefault("noteId")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "noteId", valid_594050
  var valid_594051 = query.getOrDefault("oauth_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "oauth_token", valid_594051
  var valid_594052 = query.getOrDefault("callback")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "callback", valid_594052
  var valid_594053 = query.getOrDefault("access_token")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "access_token", valid_594053
  var valid_594054 = query.getOrDefault("uploadType")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "uploadType", valid_594054
  var valid_594055 = query.getOrDefault("parent")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "parent", valid_594055
  var valid_594056 = query.getOrDefault("key")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "key", valid_594056
  var valid_594057 = query.getOrDefault("$.xgafv")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("1"))
  if valid_594057 != nil:
    section.add "$.xgafv", valid_594057
  var valid_594058 = query.getOrDefault("prettyPrint")
  valid_594058 = validateParameter(valid_594058, JBool, required = false,
                                 default = newJBool(true))
  if valid_594058 != nil:
    section.add "prettyPrint", valid_594058
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

proc call*(call_594060: Call_ContaineranalysisProvidersNotesCreate_594042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_ContaineranalysisProvidersNotesCreate_594042;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  var body_594064 = newJObject()
  add(query_594063, "upload_protocol", newJString(uploadProtocol))
  add(query_594063, "fields", newJString(fields))
  add(query_594063, "quotaUser", newJString(quotaUser))
  add(path_594062, "name", newJString(name))
  add(query_594063, "alt", newJString(alt))
  add(query_594063, "noteId", newJString(noteId))
  add(query_594063, "oauth_token", newJString(oauthToken))
  add(query_594063, "callback", newJString(callback))
  add(query_594063, "access_token", newJString(accessToken))
  add(query_594063, "uploadType", newJString(uploadType))
  add(query_594063, "parent", newJString(parent))
  add(query_594063, "key", newJString(key))
  add(query_594063, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594064 = body
  add(query_594063, "prettyPrint", newJBool(prettyPrint))
  result = call_594061.call(path_594062, query_594063, nil, nil, body_594064)

var containeranalysisProvidersNotesCreate* = Call_ContaineranalysisProvidersNotesCreate_594042(
    name: "containeranalysisProvidersNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesCreate_594043, base: "/",
    url: url_ContaineranalysisProvidersNotesCreate_594044, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetNotes_594019 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsOccurrencesGetNotes_594021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetNotes_594020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the `Note` attached to the given `Occurrence`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the occurrence in the form
  ## "projects/{project_id}/occurrences/{OCCURRENCE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594022 = path.getOrDefault("name")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "name", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   parent: JString
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594023 = query.getOrDefault("upload_protocol")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "upload_protocol", valid_594023
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("pageToken")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "pageToken", valid_594025
  var valid_594026 = query.getOrDefault("quotaUser")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "quotaUser", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("callback")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "callback", valid_594029
  var valid_594030 = query.getOrDefault("access_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "access_token", valid_594030
  var valid_594031 = query.getOrDefault("uploadType")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "uploadType", valid_594031
  var valid_594032 = query.getOrDefault("parent")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "parent", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("$.xgafv")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("1"))
  if valid_594034 != nil:
    section.add "$.xgafv", valid_594034
  var valid_594035 = query.getOrDefault("pageSize")
  valid_594035 = validateParameter(valid_594035, JInt, required = false, default = nil)
  if valid_594035 != nil:
    section.add "pageSize", valid_594035
  var valid_594036 = query.getOrDefault("prettyPrint")
  valid_594036 = validateParameter(valid_594036, JBool, required = false,
                                 default = newJBool(true))
  if valid_594036 != nil:
    section.add "prettyPrint", valid_594036
  var valid_594037 = query.getOrDefault("filter")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "filter", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_ContaineranalysisProjectsOccurrencesGetNotes_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the `Note` attached to the given `Occurrence`.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_ContaineranalysisProjectsOccurrencesGetNotes_594019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetNotes
  ## Gets the `Note` attached to the given `Occurrence`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the occurrence in the form
  ## "projects/{project_id}/occurrences/{OCCURRENCE_ID}"
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
  ##   parent: string
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "upload_protocol", newJString(uploadProtocol))
  add(query_594041, "fields", newJString(fields))
  add(query_594041, "pageToken", newJString(pageToken))
  add(query_594041, "quotaUser", newJString(quotaUser))
  add(path_594040, "name", newJString(name))
  add(query_594041, "alt", newJString(alt))
  add(query_594041, "oauth_token", newJString(oauthToken))
  add(query_594041, "callback", newJString(callback))
  add(query_594041, "access_token", newJString(accessToken))
  add(query_594041, "uploadType", newJString(uploadType))
  add(query_594041, "parent", newJString(parent))
  add(query_594041, "key", newJString(key))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  add(query_594041, "pageSize", newJInt(pageSize))
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  add(query_594041, "filter", newJString(filter))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetNotes* = Call_ContaineranalysisProjectsOccurrencesGetNotes_594019(
    name: "containeranalysisProjectsOccurrencesGetNotes",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProjectsOccurrencesGetNotes_594020,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesGetNotes_594021,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesOccurrencesList_594065 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesOccurrencesList_594067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesOccurrencesList_594066(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594068 = path.getOrDefault("name")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "name", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594069 = query.getOrDefault("upload_protocol")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "upload_protocol", valid_594069
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("pageToken")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "pageToken", valid_594071
  var valid_594072 = query.getOrDefault("quotaUser")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "quotaUser", valid_594072
  var valid_594073 = query.getOrDefault("alt")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("json"))
  if valid_594073 != nil:
    section.add "alt", valid_594073
  var valid_594074 = query.getOrDefault("oauth_token")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "oauth_token", valid_594074
  var valid_594075 = query.getOrDefault("callback")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "callback", valid_594075
  var valid_594076 = query.getOrDefault("access_token")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "access_token", valid_594076
  var valid_594077 = query.getOrDefault("uploadType")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "uploadType", valid_594077
  var valid_594078 = query.getOrDefault("key")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "key", valid_594078
  var valid_594079 = query.getOrDefault("$.xgafv")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = newJString("1"))
  if valid_594079 != nil:
    section.add "$.xgafv", valid_594079
  var valid_594080 = query.getOrDefault("pageSize")
  valid_594080 = validateParameter(valid_594080, JInt, required = false, default = nil)
  if valid_594080 != nil:
    section.add "pageSize", valid_594080
  var valid_594081 = query.getOrDefault("prettyPrint")
  valid_594081 = validateParameter(valid_594081, JBool, required = false,
                                 default = newJBool(true))
  if valid_594081 != nil:
    section.add "prettyPrint", valid_594081
  var valid_594082 = query.getOrDefault("filter")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "filter", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_ContaineranalysisProjectsNotesOccurrencesList_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_ContaineranalysisProjectsNotesOccurrencesList_594065;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesOccurrencesList
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
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
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(query_594086, "upload_protocol", newJString(uploadProtocol))
  add(query_594086, "fields", newJString(fields))
  add(query_594086, "pageToken", newJString(pageToken))
  add(query_594086, "quotaUser", newJString(quotaUser))
  add(path_594085, "name", newJString(name))
  add(query_594086, "alt", newJString(alt))
  add(query_594086, "oauth_token", newJString(oauthToken))
  add(query_594086, "callback", newJString(callback))
  add(query_594086, "access_token", newJString(accessToken))
  add(query_594086, "uploadType", newJString(uploadType))
  add(query_594086, "key", newJString(key))
  add(query_594086, "$.xgafv", newJString(Xgafv))
  add(query_594086, "pageSize", newJInt(pageSize))
  add(query_594086, "prettyPrint", newJBool(prettyPrint))
  add(query_594086, "filter", newJString(filter))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var containeranalysisProjectsNotesOccurrencesList* = Call_ContaineranalysisProjectsNotesOccurrencesList_594065(
    name: "containeranalysisProjectsNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/occurrences",
    validator: validate_ContaineranalysisProjectsNotesOccurrencesList_594066,
    base: "/", url: url_ContaineranalysisProjectsNotesOccurrencesList_594067,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_594110 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesCreate_594112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_594111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594113 = path.getOrDefault("parent")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "parent", valid_594113
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
  ##   noteId: JString
  ##         : The ID to use for this note.
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
  ##   name: JString
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594114 = query.getOrDefault("upload_protocol")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "upload_protocol", valid_594114
  var valid_594115 = query.getOrDefault("fields")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "fields", valid_594115
  var valid_594116 = query.getOrDefault("quotaUser")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "quotaUser", valid_594116
  var valid_594117 = query.getOrDefault("alt")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = newJString("json"))
  if valid_594117 != nil:
    section.add "alt", valid_594117
  var valid_594118 = query.getOrDefault("noteId")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "noteId", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("callback")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "callback", valid_594120
  var valid_594121 = query.getOrDefault("access_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "access_token", valid_594121
  var valid_594122 = query.getOrDefault("uploadType")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "uploadType", valid_594122
  var valid_594123 = query.getOrDefault("key")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "key", valid_594123
  var valid_594124 = query.getOrDefault("name")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "name", valid_594124
  var valid_594125 = query.getOrDefault("$.xgafv")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("1"))
  if valid_594125 != nil:
    section.add "$.xgafv", valid_594125
  var valid_594126 = query.getOrDefault("prettyPrint")
  valid_594126 = validateParameter(valid_594126, JBool, required = false,
                                 default = newJBool(true))
  if valid_594126 != nil:
    section.add "prettyPrint", valid_594126
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

proc call*(call_594128: Call_ContaineranalysisProjectsNotesCreate_594110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_ContaineranalysisProjectsNotesCreate_594110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  var body_594132 = newJObject()
  add(query_594131, "upload_protocol", newJString(uploadProtocol))
  add(query_594131, "fields", newJString(fields))
  add(query_594131, "quotaUser", newJString(quotaUser))
  add(query_594131, "alt", newJString(alt))
  add(query_594131, "noteId", newJString(noteId))
  add(query_594131, "oauth_token", newJString(oauthToken))
  add(query_594131, "callback", newJString(callback))
  add(query_594131, "access_token", newJString(accessToken))
  add(query_594131, "uploadType", newJString(uploadType))
  add(path_594130, "parent", newJString(parent))
  add(query_594131, "key", newJString(key))
  add(query_594131, "name", newJString(name))
  add(query_594131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594132 = body
  add(query_594131, "prettyPrint", newJBool(prettyPrint))
  result = call_594129.call(path_594130, query_594131, nil, nil, body_594132)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_594110(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_594111, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_594112, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_594087 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesList_594089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_594088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594090 = path.getOrDefault("parent")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "parent", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   name: JString
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594091 = query.getOrDefault("upload_protocol")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "upload_protocol", valid_594091
  var valid_594092 = query.getOrDefault("fields")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "fields", valid_594092
  var valid_594093 = query.getOrDefault("pageToken")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "pageToken", valid_594093
  var valid_594094 = query.getOrDefault("quotaUser")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "quotaUser", valid_594094
  var valid_594095 = query.getOrDefault("alt")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("json"))
  if valid_594095 != nil:
    section.add "alt", valid_594095
  var valid_594096 = query.getOrDefault("oauth_token")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "oauth_token", valid_594096
  var valid_594097 = query.getOrDefault("callback")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "callback", valid_594097
  var valid_594098 = query.getOrDefault("access_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "access_token", valid_594098
  var valid_594099 = query.getOrDefault("uploadType")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "uploadType", valid_594099
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("name")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "name", valid_594101
  var valid_594102 = query.getOrDefault("$.xgafv")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("1"))
  if valid_594102 != nil:
    section.add "$.xgafv", valid_594102
  var valid_594103 = query.getOrDefault("pageSize")
  valid_594103 = validateParameter(valid_594103, JInt, required = false, default = nil)
  if valid_594103 != nil:
    section.add "pageSize", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
  var valid_594105 = query.getOrDefault("filter")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "filter", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_ContaineranalysisProjectsNotesList_594087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_ContaineranalysisProjectsNotesList_594087;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists all `Notes` for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(query_594109, "upload_protocol", newJString(uploadProtocol))
  add(query_594109, "fields", newJString(fields))
  add(query_594109, "pageToken", newJString(pageToken))
  add(query_594109, "quotaUser", newJString(quotaUser))
  add(query_594109, "alt", newJString(alt))
  add(query_594109, "oauth_token", newJString(oauthToken))
  add(query_594109, "callback", newJString(callback))
  add(query_594109, "access_token", newJString(accessToken))
  add(query_594109, "uploadType", newJString(uploadType))
  add(path_594108, "parent", newJString(parent))
  add(query_594109, "key", newJString(key))
  add(query_594109, "name", newJString(name))
  add(query_594109, "$.xgafv", newJString(Xgafv))
  add(query_594109, "pageSize", newJInt(pageSize))
  add(query_594109, "prettyPrint", newJBool(prettyPrint))
  add(query_594109, "filter", newJString(filter))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_594087(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_594088, base: "/",
    url: url_ContaineranalysisProjectsNotesList_594089, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_594157 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsOccurrencesCreate_594159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_594158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{project_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594160 = path.getOrDefault("parent")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "parent", valid_594160
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
  ##   name: JString
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594161 = query.getOrDefault("upload_protocol")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "upload_protocol", valid_594161
  var valid_594162 = query.getOrDefault("fields")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "fields", valid_594162
  var valid_594163 = query.getOrDefault("quotaUser")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "quotaUser", valid_594163
  var valid_594164 = query.getOrDefault("alt")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("json"))
  if valid_594164 != nil:
    section.add "alt", valid_594164
  var valid_594165 = query.getOrDefault("oauth_token")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "oauth_token", valid_594165
  var valid_594166 = query.getOrDefault("callback")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "callback", valid_594166
  var valid_594167 = query.getOrDefault("access_token")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "access_token", valid_594167
  var valid_594168 = query.getOrDefault("uploadType")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "uploadType", valid_594168
  var valid_594169 = query.getOrDefault("key")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "key", valid_594169
  var valid_594170 = query.getOrDefault("name")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "name", valid_594170
  var valid_594171 = query.getOrDefault("$.xgafv")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = newJString("1"))
  if valid_594171 != nil:
    section.add "$.xgafv", valid_594171
  var valid_594172 = query.getOrDefault("prettyPrint")
  valid_594172 = validateParameter(valid_594172, JBool, required = false,
                                 default = newJBool(true))
  if valid_594172 != nil:
    section.add "prettyPrint", valid_594172
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

proc call*(call_594174: Call_ContaineranalysisProjectsOccurrencesCreate_594157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_ContaineranalysisProjectsOccurrencesCreate_594157;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
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
  ##         : This field contains the project Id for example: "projects/{project_id}"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(query_594177, "upload_protocol", newJString(uploadProtocol))
  add(query_594177, "fields", newJString(fields))
  add(query_594177, "quotaUser", newJString(quotaUser))
  add(query_594177, "alt", newJString(alt))
  add(query_594177, "oauth_token", newJString(oauthToken))
  add(query_594177, "callback", newJString(callback))
  add(query_594177, "access_token", newJString(accessToken))
  add(query_594177, "uploadType", newJString(uploadType))
  add(path_594176, "parent", newJString(parent))
  add(query_594177, "key", newJString(key))
  add(query_594177, "name", newJString(name))
  add(query_594177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594178 = body
  add(query_594177, "prettyPrint", newJBool(prettyPrint))
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_594157(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_594158,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_594159,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_594133 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsOccurrencesList_594135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_594134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594136 = path.getOrDefault("parent")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "parent", valid_594136
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   kind: JString
  ##       : The kind of occurrences to filter on.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594137 = query.getOrDefault("upload_protocol")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "upload_protocol", valid_594137
  var valid_594138 = query.getOrDefault("fields")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "fields", valid_594138
  var valid_594139 = query.getOrDefault("pageToken")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "pageToken", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("oauth_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "oauth_token", valid_594142
  var valid_594143 = query.getOrDefault("callback")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "callback", valid_594143
  var valid_594144 = query.getOrDefault("access_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "access_token", valid_594144
  var valid_594145 = query.getOrDefault("uploadType")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "uploadType", valid_594145
  var valid_594146 = query.getOrDefault("kind")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("KIND_UNSPECIFIED"))
  if valid_594146 != nil:
    section.add "kind", valid_594146
  var valid_594147 = query.getOrDefault("key")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "key", valid_594147
  var valid_594148 = query.getOrDefault("name")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "name", valid_594148
  var valid_594149 = query.getOrDefault("$.xgafv")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("1"))
  if valid_594149 != nil:
    section.add "$.xgafv", valid_594149
  var valid_594150 = query.getOrDefault("pageSize")
  valid_594150 = validateParameter(valid_594150, JInt, required = false, default = nil)
  if valid_594150 != nil:
    section.add "pageSize", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
  var valid_594152 = query.getOrDefault("filter")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "filter", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_ContaineranalysisProjectsOccurrencesList_594133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ContaineranalysisProjectsOccurrencesList_594133;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = "KIND_UNSPECIFIED"; key: string = "";
          name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists active `Occurrences` for a given project matching the filters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : This contains the project Id for example: projects/{project_id}.
  ##   kind: string
  ##       : The kind of occurrences to filter on.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(query_594156, "upload_protocol", newJString(uploadProtocol))
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "pageToken", newJString(pageToken))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "callback", newJString(callback))
  add(query_594156, "access_token", newJString(accessToken))
  add(query_594156, "uploadType", newJString(uploadType))
  add(path_594155, "parent", newJString(parent))
  add(query_594156, "kind", newJString(kind))
  add(query_594156, "key", newJString(key))
  add(query_594156, "name", newJString(name))
  add(query_594156, "$.xgafv", newJString(Xgafv))
  add(query_594156, "pageSize", newJInt(pageSize))
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  add(query_594156, "filter", newJString(filter))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_594133(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_594134,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_594135,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594179 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594180(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594182 = path.getOrDefault("parent")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "parent", valid_594182
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
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594183 = query.getOrDefault("upload_protocol")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "upload_protocol", valid_594183
  var valid_594184 = query.getOrDefault("fields")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "fields", valid_594184
  var valid_594185 = query.getOrDefault("quotaUser")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "quotaUser", valid_594185
  var valid_594186 = query.getOrDefault("alt")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = newJString("json"))
  if valid_594186 != nil:
    section.add "alt", valid_594186
  var valid_594187 = query.getOrDefault("oauth_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "oauth_token", valid_594187
  var valid_594188 = query.getOrDefault("callback")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "callback", valid_594188
  var valid_594189 = query.getOrDefault("access_token")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "access_token", valid_594189
  var valid_594190 = query.getOrDefault("uploadType")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "uploadType", valid_594190
  var valid_594191 = query.getOrDefault("key")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "key", valid_594191
  var valid_594192 = query.getOrDefault("$.xgafv")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = newJString("1"))
  if valid_594192 != nil:
    section.add "$.xgafv", valid_594192
  var valid_594193 = query.getOrDefault("prettyPrint")
  valid_594193 = validateParameter(valid_594193, JBool, required = false,
                                 default = newJBool(true))
  if valid_594193 != nil:
    section.add "prettyPrint", valid_594193
  var valid_594194 = query.getOrDefault("filter")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "filter", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594179;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##         : This contains the project Id for example: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(query_594198, "upload_protocol", newJString(uploadProtocol))
  add(query_594198, "fields", newJString(fields))
  add(query_594198, "quotaUser", newJString(quotaUser))
  add(query_594198, "alt", newJString(alt))
  add(query_594198, "oauth_token", newJString(oauthToken))
  add(query_594198, "callback", newJString(callback))
  add(query_594198, "access_token", newJString(accessToken))
  add(query_594198, "uploadType", newJString(uploadType))
  add(path_594197, "parent", newJString(parent))
  add(query_594198, "key", newJString(key))
  add(query_594198, "$.xgafv", newJString(Xgafv))
  add(query_594198, "prettyPrint", newJBool(prettyPrint))
  add(query_594198, "filter", newJString(filter))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594179(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594180,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_594181,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOperationsCreate_594199 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsOperationsCreate_594201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOperationsCreate_594200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Operation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project Id that this operation should be created under.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594202 = path.getOrDefault("parent")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "parent", valid_594202
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
  var valid_594203 = query.getOrDefault("upload_protocol")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "upload_protocol", valid_594203
  var valid_594204 = query.getOrDefault("fields")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "fields", valid_594204
  var valid_594205 = query.getOrDefault("quotaUser")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "quotaUser", valid_594205
  var valid_594206 = query.getOrDefault("alt")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = newJString("json"))
  if valid_594206 != nil:
    section.add "alt", valid_594206
  var valid_594207 = query.getOrDefault("oauth_token")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "oauth_token", valid_594207
  var valid_594208 = query.getOrDefault("callback")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "callback", valid_594208
  var valid_594209 = query.getOrDefault("access_token")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "access_token", valid_594209
  var valid_594210 = query.getOrDefault("uploadType")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "uploadType", valid_594210
  var valid_594211 = query.getOrDefault("key")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "key", valid_594211
  var valid_594212 = query.getOrDefault("$.xgafv")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = newJString("1"))
  if valid_594212 != nil:
    section.add "$.xgafv", valid_594212
  var valid_594213 = query.getOrDefault("prettyPrint")
  valid_594213 = validateParameter(valid_594213, JBool, required = false,
                                 default = newJBool(true))
  if valid_594213 != nil:
    section.add "prettyPrint", valid_594213
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

proc call*(call_594215: Call_ContaineranalysisProjectsOperationsCreate_594199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Operation`.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_ContaineranalysisProjectsOperationsCreate_594199;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOperationsCreate
  ## Creates a new `Operation`.
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
  ##         : The project Id that this operation should be created under.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  var body_594219 = newJObject()
  add(query_594218, "upload_protocol", newJString(uploadProtocol))
  add(query_594218, "fields", newJString(fields))
  add(query_594218, "quotaUser", newJString(quotaUser))
  add(query_594218, "alt", newJString(alt))
  add(query_594218, "oauth_token", newJString(oauthToken))
  add(query_594218, "callback", newJString(callback))
  add(query_594218, "access_token", newJString(accessToken))
  add(query_594218, "uploadType", newJString(uploadType))
  add(path_594217, "parent", newJString(parent))
  add(query_594218, "key", newJString(key))
  add(query_594218, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594219 = body
  add(query_594218, "prettyPrint", newJBool(prettyPrint))
  result = call_594216.call(path_594217, query_594218, nil, nil, body_594219)

var containeranalysisProjectsOperationsCreate* = Call_ContaineranalysisProjectsOperationsCreate_594199(
    name: "containeranalysisProjectsOperationsCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/operations",
    validator: validate_ContaineranalysisProjectsOperationsCreate_594200,
    base: "/", url: url_ContaineranalysisProjectsOperationsCreate_594201,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_594220 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsScanConfigsList_594222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_594221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594223 = path.getOrDefault("parent")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "parent", valid_594223
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The page token to use for the next request.
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
  ##           : The number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_594224 = query.getOrDefault("upload_protocol")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "upload_protocol", valid_594224
  var valid_594225 = query.getOrDefault("fields")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "fields", valid_594225
  var valid_594226 = query.getOrDefault("pageToken")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "pageToken", valid_594226
  var valid_594227 = query.getOrDefault("quotaUser")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "quotaUser", valid_594227
  var valid_594228 = query.getOrDefault("alt")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = newJString("json"))
  if valid_594228 != nil:
    section.add "alt", valid_594228
  var valid_594229 = query.getOrDefault("oauth_token")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "oauth_token", valid_594229
  var valid_594230 = query.getOrDefault("callback")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "callback", valid_594230
  var valid_594231 = query.getOrDefault("access_token")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "access_token", valid_594231
  var valid_594232 = query.getOrDefault("uploadType")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "uploadType", valid_594232
  var valid_594233 = query.getOrDefault("key")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "key", valid_594233
  var valid_594234 = query.getOrDefault("$.xgafv")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("1"))
  if valid_594234 != nil:
    section.add "$.xgafv", valid_594234
  var valid_594235 = query.getOrDefault("pageSize")
  valid_594235 = validateParameter(valid_594235, JInt, required = false, default = nil)
  if valid_594235 != nil:
    section.add "pageSize", valid_594235
  var valid_594236 = query.getOrDefault("prettyPrint")
  valid_594236 = validateParameter(valid_594236, JBool, required = false,
                                 default = newJBool(true))
  if valid_594236 != nil:
    section.add "prettyPrint", valid_594236
  var valid_594237 = query.getOrDefault("filter")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "filter", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_ContaineranalysisProjectsScanConfigsList_594220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for a project.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_ContaineranalysisProjectsScanConfigsList_594220;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The page token to use for the next request.
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
  ##         : This containers the project Id i.e.: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  add(query_594241, "upload_protocol", newJString(uploadProtocol))
  add(query_594241, "fields", newJString(fields))
  add(query_594241, "pageToken", newJString(pageToken))
  add(query_594241, "quotaUser", newJString(quotaUser))
  add(query_594241, "alt", newJString(alt))
  add(query_594241, "oauth_token", newJString(oauthToken))
  add(query_594241, "callback", newJString(callback))
  add(query_594241, "access_token", newJString(accessToken))
  add(query_594241, "uploadType", newJString(uploadType))
  add(path_594240, "parent", newJString(parent))
  add(query_594241, "key", newJString(key))
  add(query_594241, "$.xgafv", newJString(Xgafv))
  add(query_594241, "pageSize", newJInt(pageSize))
  add(query_594241, "prettyPrint", newJBool(prettyPrint))
  add(query_594241, "filter", newJString(filter))
  result = call_594239.call(path_594240, query_594241, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_594220(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_594221,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_594222,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesGetIamPolicy_594242 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesGetIamPolicy_594244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesGetIamPolicy_594243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594245 = path.getOrDefault("resource")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "resource", valid_594245
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
  var valid_594246 = query.getOrDefault("upload_protocol")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "upload_protocol", valid_594246
  var valid_594247 = query.getOrDefault("fields")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "fields", valid_594247
  var valid_594248 = query.getOrDefault("quotaUser")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "quotaUser", valid_594248
  var valid_594249 = query.getOrDefault("alt")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = newJString("json"))
  if valid_594249 != nil:
    section.add "alt", valid_594249
  var valid_594250 = query.getOrDefault("oauth_token")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "oauth_token", valid_594250
  var valid_594251 = query.getOrDefault("callback")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "callback", valid_594251
  var valid_594252 = query.getOrDefault("access_token")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "access_token", valid_594252
  var valid_594253 = query.getOrDefault("uploadType")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "uploadType", valid_594253
  var valid_594254 = query.getOrDefault("key")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "key", valid_594254
  var valid_594255 = query.getOrDefault("$.xgafv")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = newJString("1"))
  if valid_594255 != nil:
    section.add "$.xgafv", valid_594255
  var valid_594256 = query.getOrDefault("prettyPrint")
  valid_594256 = validateParameter(valid_594256, JBool, required = false,
                                 default = newJBool(true))
  if valid_594256 != nil:
    section.add "prettyPrint", valid_594256
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

proc call*(call_594258: Call_ContaineranalysisProjectsNotesGetIamPolicy_594242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_ContaineranalysisProjectsNotesGetIamPolicy_594242;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesGetIamPolicy
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
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
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  var body_594262 = newJObject()
  add(query_594261, "upload_protocol", newJString(uploadProtocol))
  add(query_594261, "fields", newJString(fields))
  add(query_594261, "quotaUser", newJString(quotaUser))
  add(query_594261, "alt", newJString(alt))
  add(query_594261, "oauth_token", newJString(oauthToken))
  add(query_594261, "callback", newJString(callback))
  add(query_594261, "access_token", newJString(accessToken))
  add(query_594261, "uploadType", newJString(uploadType))
  add(query_594261, "key", newJString(key))
  add(query_594261, "$.xgafv", newJString(Xgafv))
  add(path_594260, "resource", newJString(resource))
  if body != nil:
    body_594262 = body
  add(query_594261, "prettyPrint", newJBool(prettyPrint))
  result = call_594259.call(path_594260, query_594261, nil, nil, body_594262)

var containeranalysisProjectsNotesGetIamPolicy* = Call_ContaineranalysisProjectsNotesGetIamPolicy_594242(
    name: "containeranalysisProjectsNotesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesGetIamPolicy_594243,
    base: "/", url: url_ContaineranalysisProjectsNotesGetIamPolicy_594244,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesSetIamPolicy_594263 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesSetIamPolicy_594265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesSetIamPolicy_594264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594266 = path.getOrDefault("resource")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "resource", valid_594266
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
  var valid_594267 = query.getOrDefault("upload_protocol")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "upload_protocol", valid_594267
  var valid_594268 = query.getOrDefault("fields")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "fields", valid_594268
  var valid_594269 = query.getOrDefault("quotaUser")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "quotaUser", valid_594269
  var valid_594270 = query.getOrDefault("alt")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = newJString("json"))
  if valid_594270 != nil:
    section.add "alt", valid_594270
  var valid_594271 = query.getOrDefault("oauth_token")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "oauth_token", valid_594271
  var valid_594272 = query.getOrDefault("callback")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "callback", valid_594272
  var valid_594273 = query.getOrDefault("access_token")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "access_token", valid_594273
  var valid_594274 = query.getOrDefault("uploadType")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "uploadType", valid_594274
  var valid_594275 = query.getOrDefault("key")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "key", valid_594275
  var valid_594276 = query.getOrDefault("$.xgafv")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = newJString("1"))
  if valid_594276 != nil:
    section.add "$.xgafv", valid_594276
  var valid_594277 = query.getOrDefault("prettyPrint")
  valid_594277 = validateParameter(valid_594277, JBool, required = false,
                                 default = newJBool(true))
  if valid_594277 != nil:
    section.add "prettyPrint", valid_594277
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

proc call*(call_594279: Call_ContaineranalysisProjectsNotesSetIamPolicy_594263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_ContaineranalysisProjectsNotesSetIamPolicy_594263;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesSetIamPolicy
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
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
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  var body_594283 = newJObject()
  add(query_594282, "upload_protocol", newJString(uploadProtocol))
  add(query_594282, "fields", newJString(fields))
  add(query_594282, "quotaUser", newJString(quotaUser))
  add(query_594282, "alt", newJString(alt))
  add(query_594282, "oauth_token", newJString(oauthToken))
  add(query_594282, "callback", newJString(callback))
  add(query_594282, "access_token", newJString(accessToken))
  add(query_594282, "uploadType", newJString(uploadType))
  add(query_594282, "key", newJString(key))
  add(query_594282, "$.xgafv", newJString(Xgafv))
  add(path_594281, "resource", newJString(resource))
  if body != nil:
    body_594283 = body
  add(query_594282, "prettyPrint", newJBool(prettyPrint))
  result = call_594280.call(path_594281, query_594282, nil, nil, body_594283)

var containeranalysisProjectsNotesSetIamPolicy* = Call_ContaineranalysisProjectsNotesSetIamPolicy_594263(
    name: "containeranalysisProjectsNotesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesSetIamPolicy_594264,
    base: "/", url: url_ContaineranalysisProjectsNotesSetIamPolicy_594265,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesTestIamPermissions_594284 = ref object of OpenApiRestCall_593421
proc url_ContaineranalysisProjectsNotesTestIamPermissions_594286(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesTestIamPermissions_594285(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594287 = path.getOrDefault("resource")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "resource", valid_594287
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
  var valid_594288 = query.getOrDefault("upload_protocol")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "upload_protocol", valid_594288
  var valid_594289 = query.getOrDefault("fields")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "fields", valid_594289
  var valid_594290 = query.getOrDefault("quotaUser")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "quotaUser", valid_594290
  var valid_594291 = query.getOrDefault("alt")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = newJString("json"))
  if valid_594291 != nil:
    section.add "alt", valid_594291
  var valid_594292 = query.getOrDefault("oauth_token")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "oauth_token", valid_594292
  var valid_594293 = query.getOrDefault("callback")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "callback", valid_594293
  var valid_594294 = query.getOrDefault("access_token")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "access_token", valid_594294
  var valid_594295 = query.getOrDefault("uploadType")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "uploadType", valid_594295
  var valid_594296 = query.getOrDefault("key")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "key", valid_594296
  var valid_594297 = query.getOrDefault("$.xgafv")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("1"))
  if valid_594297 != nil:
    section.add "$.xgafv", valid_594297
  var valid_594298 = query.getOrDefault("prettyPrint")
  valid_594298 = validateParameter(valid_594298, JBool, required = false,
                                 default = newJBool(true))
  if valid_594298 != nil:
    section.add "prettyPrint", valid_594298
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

proc call*(call_594300: Call_ContaineranalysisProjectsNotesTestIamPermissions_594284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  let valid = call_594300.validator(path, query, header, formData, body)
  let scheme = call_594300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594300.url(scheme.get, call_594300.host, call_594300.base,
                         call_594300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594300, url, valid)

proc call*(call_594301: Call_ContaineranalysisProjectsNotesTestIamPermissions_594284;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
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
  var path_594302 = newJObject()
  var query_594303 = newJObject()
  var body_594304 = newJObject()
  add(query_594303, "upload_protocol", newJString(uploadProtocol))
  add(query_594303, "fields", newJString(fields))
  add(query_594303, "quotaUser", newJString(quotaUser))
  add(query_594303, "alt", newJString(alt))
  add(query_594303, "oauth_token", newJString(oauthToken))
  add(query_594303, "callback", newJString(callback))
  add(query_594303, "access_token", newJString(accessToken))
  add(query_594303, "uploadType", newJString(uploadType))
  add(query_594303, "key", newJString(key))
  add(query_594303, "$.xgafv", newJString(Xgafv))
  add(path_594302, "resource", newJString(resource))
  if body != nil:
    body_594304 = body
  add(query_594303, "prettyPrint", newJBool(prettyPrint))
  result = call_594301.call(path_594302, query_594303, nil, nil, body_594304)

var containeranalysisProjectsNotesTestIamPermissions* = Call_ContaineranalysisProjectsNotesTestIamPermissions_594284(
    name: "containeranalysisProjectsNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProjectsNotesTestIamPermissions_594285,
    base: "/", url: url_ContaineranalysisProjectsNotesTestIamPermissions_594286,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
