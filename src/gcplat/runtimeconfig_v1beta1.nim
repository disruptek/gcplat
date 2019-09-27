
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Runtime Configuration
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Runtime Configurator allows you to dynamically configure and expose variables through Google Cloud Platform. In addition, you can also set Watchers and Waiters that will watch for changes to your data and return based on certain conditions.
## 
## https://cloud.google.com/deployment-manager/runtime-configurator/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "runtimeconfig"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RuntimeconfigProjectsConfigsVariablesUpdate_593965 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesUpdate_593967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesUpdate_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing variable with a new value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the variable to update, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
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

proc call*(call_593981: Call_RuntimeconfigProjectsConfigsVariablesUpdate_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing variable with a new value.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_RuntimeconfigProjectsConfigsVariablesUpdate_593965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsVariablesUpdate
  ## Updates an existing variable with a new value.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to update, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  var body_593985 = newJObject()
  add(query_593984, "upload_protocol", newJString(uploadProtocol))
  add(query_593984, "fields", newJString(fields))
  add(query_593984, "quotaUser", newJString(quotaUser))
  add(path_593983, "name", newJString(name))
  add(query_593984, "alt", newJString(alt))
  add(query_593984, "oauth_token", newJString(oauthToken))
  add(query_593984, "callback", newJString(callback))
  add(query_593984, "access_token", newJString(accessToken))
  add(query_593984, "uploadType", newJString(uploadType))
  add(query_593984, "key", newJString(key))
  add(query_593984, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593985 = body
  add(query_593984, "prettyPrint", newJBool(prettyPrint))
  result = call_593982.call(path_593983, query_593984, nil, nil, body_593985)

var runtimeconfigProjectsConfigsVariablesUpdate* = Call_RuntimeconfigProjectsConfigsVariablesUpdate_593965(
    name: "runtimeconfigProjectsConfigsVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesUpdate_593966,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesUpdate_593967,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesGet_593677 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesGet_593679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesGet_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a single variable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the variable to return, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIBLE_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_RuntimeconfigProjectsConfigsVariablesGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a single variable.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_RuntimeconfigProjectsConfigsVariablesGet_593677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsVariablesGet
  ## Gets information about a single variable.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to return, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIBLE_NAME]`
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesGet* = Call_RuntimeconfigProjectsConfigsVariablesGet_593677(
    name: "runtimeconfigProjectsConfigsVariablesGet", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesGet_593678,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesGet_593679,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesDelete_593986 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesDelete_593988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesDelete_593987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a variable or multiple variables.
  ## 
  ## If you specify a variable name, then that variable is deleted. If you
  ## specify a prefix and `recursive` is true, then all variables with that
  ## prefix are deleted. You must set a `recursive` to true if you delete
  ## variables by prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the variable to delete, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593989 = path.getOrDefault("name")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "name", valid_593989
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
  ##   recursive: JBool
  ##            : Set to `true` to recursively delete multiple variables with the same
  ## prefix.
  section = newJObject()
  var valid_593990 = query.getOrDefault("upload_protocol")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "upload_protocol", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("callback")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "callback", valid_593995
  var valid_593996 = query.getOrDefault("access_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "access_token", valid_593996
  var valid_593997 = query.getOrDefault("uploadType")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "uploadType", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("$.xgafv")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("1"))
  if valid_593999 != nil:
    section.add "$.xgafv", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
  var valid_594001 = query.getOrDefault("recursive")
  valid_594001 = validateParameter(valid_594001, JBool, required = false, default = nil)
  if valid_594001 != nil:
    section.add "recursive", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_RuntimeconfigProjectsConfigsVariablesDelete_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a variable or multiple variables.
  ## 
  ## If you specify a variable name, then that variable is deleted. If you
  ## specify a prefix and `recursive` is true, then all variables with that
  ## prefix are deleted. You must set a `recursive` to true if you delete
  ## variables by prefix.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_RuntimeconfigProjectsConfigsVariablesDelete_593986;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          recursive: bool = false): Recallable =
  ## runtimeconfigProjectsConfigsVariablesDelete
  ## Deletes a variable or multiple variables.
  ## 
  ## If you specify a variable name, then that variable is deleted. If you
  ## specify a prefix and `recursive` is true, then all variables with that
  ## prefix are deleted. You must set a `recursive` to true if you delete
  ## variables by prefix.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to delete, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
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
  ##   recursive: bool
  ##            : Set to `true` to recursively delete multiple variables with the same
  ## prefix.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "upload_protocol", newJString(uploadProtocol))
  add(query_594005, "fields", newJString(fields))
  add(query_594005, "quotaUser", newJString(quotaUser))
  add(path_594004, "name", newJString(name))
  add(query_594005, "alt", newJString(alt))
  add(query_594005, "oauth_token", newJString(oauthToken))
  add(query_594005, "callback", newJString(callback))
  add(query_594005, "access_token", newJString(accessToken))
  add(query_594005, "uploadType", newJString(uploadType))
  add(query_594005, "key", newJString(key))
  add(query_594005, "$.xgafv", newJString(Xgafv))
  add(query_594005, "prettyPrint", newJBool(prettyPrint))
  add(query_594005, "recursive", newJBool(recursive))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesDelete* = Call_RuntimeconfigProjectsConfigsVariablesDelete_593986(
    name: "runtimeconfigProjectsConfigsVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesDelete_593987,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesDelete_593988,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesWatch_594006 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesWatch_594008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesWatch_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watches a specific variable and waits for a change in the variable's value.
  ## When there is a change, this method returns the new value or times out.
  ## 
  ## If a variable is deleted while being watched, the `variableState` state is
  ## set to `DELETED` and the method returns the last known variable `value`.
  ## 
  ## If you set the deadline for watching to a larger value than internal
  ## timeout (60 seconds), the current variable value is returned and the
  ## `variableState` will be `VARIABLE_STATE_UNSPECIFIED`.
  ## 
  ## To learn more about creating a watcher, read the
  ## [Watching a Variable for
  ## Changes](/deployment-manager/runtime-configurator/watching-a-variable)
  ## documentation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the variable to watch, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594009 = path.getOrDefault("name")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "name", valid_594009
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
  var valid_594010 = query.getOrDefault("upload_protocol")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "upload_protocol", valid_594010
  var valid_594011 = query.getOrDefault("fields")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "fields", valid_594011
  var valid_594012 = query.getOrDefault("quotaUser")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "quotaUser", valid_594012
  var valid_594013 = query.getOrDefault("alt")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("json"))
  if valid_594013 != nil:
    section.add "alt", valid_594013
  var valid_594014 = query.getOrDefault("oauth_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "oauth_token", valid_594014
  var valid_594015 = query.getOrDefault("callback")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "callback", valid_594015
  var valid_594016 = query.getOrDefault("access_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "access_token", valid_594016
  var valid_594017 = query.getOrDefault("uploadType")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "uploadType", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("$.xgafv")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("1"))
  if valid_594019 != nil:
    section.add "$.xgafv", valid_594019
  var valid_594020 = query.getOrDefault("prettyPrint")
  valid_594020 = validateParameter(valid_594020, JBool, required = false,
                                 default = newJBool(true))
  if valid_594020 != nil:
    section.add "prettyPrint", valid_594020
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

proc call*(call_594022: Call_RuntimeconfigProjectsConfigsVariablesWatch_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Watches a specific variable and waits for a change in the variable's value.
  ## When there is a change, this method returns the new value or times out.
  ## 
  ## If a variable is deleted while being watched, the `variableState` state is
  ## set to `DELETED` and the method returns the last known variable `value`.
  ## 
  ## If you set the deadline for watching to a larger value than internal
  ## timeout (60 seconds), the current variable value is returned and the
  ## `variableState` will be `VARIABLE_STATE_UNSPECIFIED`.
  ## 
  ## To learn more about creating a watcher, read the
  ## [Watching a Variable for
  ## Changes](/deployment-manager/runtime-configurator/watching-a-variable)
  ## documentation.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_RuntimeconfigProjectsConfigsVariablesWatch_594006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsVariablesWatch
  ## Watches a specific variable and waits for a change in the variable's value.
  ## When there is a change, this method returns the new value or times out.
  ## 
  ## If a variable is deleted while being watched, the `variableState` state is
  ## set to `DELETED` and the method returns the last known variable `value`.
  ## 
  ## If you set the deadline for watching to a larger value than internal
  ## timeout (60 seconds), the current variable value is returned and the
  ## `variableState` will be `VARIABLE_STATE_UNSPECIFIED`.
  ## 
  ## To learn more about creating a watcher, read the
  ## [Watching a Variable for
  ## Changes](/deployment-manager/runtime-configurator/watching-a-variable)
  ## documentation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to watch, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  var body_594026 = newJObject()
  add(query_594025, "upload_protocol", newJString(uploadProtocol))
  add(query_594025, "fields", newJString(fields))
  add(query_594025, "quotaUser", newJString(quotaUser))
  add(path_594024, "name", newJString(name))
  add(query_594025, "alt", newJString(alt))
  add(query_594025, "oauth_token", newJString(oauthToken))
  add(query_594025, "callback", newJString(callback))
  add(query_594025, "access_token", newJString(accessToken))
  add(query_594025, "uploadType", newJString(uploadType))
  add(query_594025, "key", newJString(key))
  add(query_594025, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594026 = body
  add(query_594025, "prettyPrint", newJBool(prettyPrint))
  result = call_594023.call(path_594024, query_594025, nil, nil, body_594026)

var runtimeconfigProjectsConfigsVariablesWatch* = Call_RuntimeconfigProjectsConfigsVariablesWatch_594006(
    name: "runtimeconfigProjectsConfigsVariablesWatch", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}:watch",
    validator: validate_RuntimeconfigProjectsConfigsVariablesWatch_594007,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesWatch_594008,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsCreate_594048 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsCreate_594050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsCreate_594049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new RuntimeConfig resource. The configuration name must be
  ## unique within project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594051 = path.getOrDefault("parent")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "parent", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  var valid_594052 = query.getOrDefault("upload_protocol")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "upload_protocol", valid_594052
  var valid_594053 = query.getOrDefault("fields")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "fields", valid_594053
  var valid_594054 = query.getOrDefault("requestId")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "requestId", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("callback")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "callback", valid_594058
  var valid_594059 = query.getOrDefault("access_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "access_token", valid_594059
  var valid_594060 = query.getOrDefault("uploadType")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "uploadType", valid_594060
  var valid_594061 = query.getOrDefault("key")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "key", valid_594061
  var valid_594062 = query.getOrDefault("$.xgafv")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("1"))
  if valid_594062 != nil:
    section.add "$.xgafv", valid_594062
  var valid_594063 = query.getOrDefault("prettyPrint")
  valid_594063 = validateParameter(valid_594063, JBool, required = false,
                                 default = newJBool(true))
  if valid_594063 != nil:
    section.add "prettyPrint", valid_594063
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

proc call*(call_594065: Call_RuntimeconfigProjectsConfigsCreate_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new RuntimeConfig resource. The configuration name must be
  ## unique within project.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_RuntimeconfigProjectsConfigsCreate_594048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsCreate
  ## Creates a new RuntimeConfig resource. The configuration name must be
  ## unique within project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  var body_594069 = newJObject()
  add(query_594068, "upload_protocol", newJString(uploadProtocol))
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "requestId", newJString(requestId))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(query_594068, "callback", newJString(callback))
  add(query_594068, "access_token", newJString(accessToken))
  add(query_594068, "uploadType", newJString(uploadType))
  add(path_594067, "parent", newJString(parent))
  add(query_594068, "key", newJString(key))
  add(query_594068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594069 = body
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  result = call_594066.call(path_594067, query_594068, nil, nil, body_594069)

var runtimeconfigProjectsConfigsCreate* = Call_RuntimeconfigProjectsConfigsCreate_594048(
    name: "runtimeconfigProjectsConfigsCreate", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/configs",
    validator: validate_RuntimeconfigProjectsConfigsCreate_594049, base: "/",
    url: url_RuntimeconfigProjectsConfigsCreate_594050, schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsList_594027 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsList_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsList_594028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the RuntimeConfig resources within project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594030 = path.getOrDefault("parent")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "parent", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594031 = query.getOrDefault("upload_protocol")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "upload_protocol", valid_594031
  var valid_594032 = query.getOrDefault("fields")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fields", valid_594032
  var valid_594033 = query.getOrDefault("pageToken")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "pageToken", valid_594033
  var valid_594034 = query.getOrDefault("quotaUser")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "quotaUser", valid_594034
  var valid_594035 = query.getOrDefault("alt")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("json"))
  if valid_594035 != nil:
    section.add "alt", valid_594035
  var valid_594036 = query.getOrDefault("oauth_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "oauth_token", valid_594036
  var valid_594037 = query.getOrDefault("callback")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "callback", valid_594037
  var valid_594038 = query.getOrDefault("access_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "access_token", valid_594038
  var valid_594039 = query.getOrDefault("uploadType")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "uploadType", valid_594039
  var valid_594040 = query.getOrDefault("key")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "key", valid_594040
  var valid_594041 = query.getOrDefault("$.xgafv")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = newJString("1"))
  if valid_594041 != nil:
    section.add "$.xgafv", valid_594041
  var valid_594042 = query.getOrDefault("pageSize")
  valid_594042 = validateParameter(valid_594042, JInt, required = false, default = nil)
  if valid_594042 != nil:
    section.add "pageSize", valid_594042
  var valid_594043 = query.getOrDefault("prettyPrint")
  valid_594043 = validateParameter(valid_594043, JBool, required = false,
                                 default = newJBool(true))
  if valid_594043 != nil:
    section.add "prettyPrint", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_RuntimeconfigProjectsConfigsList_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the RuntimeConfig resources within project.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_RuntimeconfigProjectsConfigsList_594027;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsList
  ## Lists all the RuntimeConfig resources within project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "upload_protocol", newJString(uploadProtocol))
  add(query_594047, "fields", newJString(fields))
  add(query_594047, "pageToken", newJString(pageToken))
  add(query_594047, "quotaUser", newJString(quotaUser))
  add(query_594047, "alt", newJString(alt))
  add(query_594047, "oauth_token", newJString(oauthToken))
  add(query_594047, "callback", newJString(callback))
  add(query_594047, "access_token", newJString(accessToken))
  add(query_594047, "uploadType", newJString(uploadType))
  add(path_594046, "parent", newJString(parent))
  add(query_594047, "key", newJString(key))
  add(query_594047, "$.xgafv", newJString(Xgafv))
  add(query_594047, "pageSize", newJInt(pageSize))
  add(query_594047, "prettyPrint", newJBool(prettyPrint))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var runtimeconfigProjectsConfigsList* = Call_RuntimeconfigProjectsConfigsList_594027(
    name: "runtimeconfigProjectsConfigsList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/configs",
    validator: validate_RuntimeconfigProjectsConfigsList_594028, base: "/",
    url: url_RuntimeconfigProjectsConfigsList_594029, schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesCreate_594093 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesCreate_594095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/variables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesCreate_594094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a variable within the given configuration. You cannot create
  ## a variable with a name that is a prefix of an existing variable name, or a
  ## name that has an existing variable name as a prefix.
  ## 
  ## To learn more about creating a variable, read the
  ## [Setting and Getting
  ## Data](/deployment-manager/runtime-configurator/set-and-get-variables)
  ## documentation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The path to the RutimeConfig resource that this variable should belong to.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594096 = path.getOrDefault("parent")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "parent", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  var valid_594097 = query.getOrDefault("upload_protocol")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "upload_protocol", valid_594097
  var valid_594098 = query.getOrDefault("fields")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "fields", valid_594098
  var valid_594099 = query.getOrDefault("requestId")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "requestId", valid_594099
  var valid_594100 = query.getOrDefault("quotaUser")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "quotaUser", valid_594100
  var valid_594101 = query.getOrDefault("alt")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = newJString("json"))
  if valid_594101 != nil:
    section.add "alt", valid_594101
  var valid_594102 = query.getOrDefault("oauth_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "oauth_token", valid_594102
  var valid_594103 = query.getOrDefault("callback")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "callback", valid_594103
  var valid_594104 = query.getOrDefault("access_token")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "access_token", valid_594104
  var valid_594105 = query.getOrDefault("uploadType")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "uploadType", valid_594105
  var valid_594106 = query.getOrDefault("key")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "key", valid_594106
  var valid_594107 = query.getOrDefault("$.xgafv")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("1"))
  if valid_594107 != nil:
    section.add "$.xgafv", valid_594107
  var valid_594108 = query.getOrDefault("prettyPrint")
  valid_594108 = validateParameter(valid_594108, JBool, required = false,
                                 default = newJBool(true))
  if valid_594108 != nil:
    section.add "prettyPrint", valid_594108
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

proc call*(call_594110: Call_RuntimeconfigProjectsConfigsVariablesCreate_594093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a variable within the given configuration. You cannot create
  ## a variable with a name that is a prefix of an existing variable name, or a
  ## name that has an existing variable name as a prefix.
  ## 
  ## To learn more about creating a variable, read the
  ## [Setting and Getting
  ## Data](/deployment-manager/runtime-configurator/set-and-get-variables)
  ## documentation.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_RuntimeconfigProjectsConfigsVariablesCreate_594093;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsVariablesCreate
  ## Creates a variable within the given configuration. You cannot create
  ## a variable with a name that is a prefix of an existing variable name, or a
  ## name that has an existing variable name as a prefix.
  ## 
  ## To learn more about creating a variable, read the
  ## [Setting and Getting
  ## Data](/deployment-manager/runtime-configurator/set-and-get-variables)
  ## documentation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  ##         : The path to the RutimeConfig resource that this variable should belong to.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  var body_594114 = newJObject()
  add(query_594113, "upload_protocol", newJString(uploadProtocol))
  add(query_594113, "fields", newJString(fields))
  add(query_594113, "requestId", newJString(requestId))
  add(query_594113, "quotaUser", newJString(quotaUser))
  add(query_594113, "alt", newJString(alt))
  add(query_594113, "oauth_token", newJString(oauthToken))
  add(query_594113, "callback", newJString(callback))
  add(query_594113, "access_token", newJString(accessToken))
  add(query_594113, "uploadType", newJString(uploadType))
  add(path_594112, "parent", newJString(parent))
  add(query_594113, "key", newJString(key))
  add(query_594113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594114 = body
  add(query_594113, "prettyPrint", newJBool(prettyPrint))
  result = call_594111.call(path_594112, query_594113, nil, nil, body_594114)

var runtimeconfigProjectsConfigsVariablesCreate* = Call_RuntimeconfigProjectsConfigsVariablesCreate_594093(
    name: "runtimeconfigProjectsConfigsVariablesCreate",
    meth: HttpMethod.HttpPost, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{parent}/variables",
    validator: validate_RuntimeconfigProjectsConfigsVariablesCreate_594094,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesCreate_594095,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesList_594070 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesList_594072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/variables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesList_594071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists variables within given a configuration, matching any provided
  ## filters. This only lists variable names, not the values, unless
  ## `return_values` is true, in which case only variables that user has IAM
  ## permission to GetVariable will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The path to the RuntimeConfig resource for which you want to list
  ## variables. The configuration must exist beforehand; the path must be in the
  ## format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594073 = path.getOrDefault("parent")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "parent", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   returnValues: JBool
  ##               : The flag indicates whether the user wants to return values of variables.
  ## If true, then only those variables that user has IAM GetVariable permission
  ## will be returned along with their values.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Filters variables by matching the specified filter. For example:
  ## 
  ## `projects/example-project/config/[CONFIG_NAME]/variables/example-variable`.
  section = newJObject()
  var valid_594074 = query.getOrDefault("upload_protocol")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "upload_protocol", valid_594074
  var valid_594075 = query.getOrDefault("fields")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "fields", valid_594075
  var valid_594076 = query.getOrDefault("pageToken")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "pageToken", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  var valid_594079 = query.getOrDefault("returnValues")
  valid_594079 = validateParameter(valid_594079, JBool, required = false, default = nil)
  if valid_594079 != nil:
    section.add "returnValues", valid_594079
  var valid_594080 = query.getOrDefault("oauth_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "oauth_token", valid_594080
  var valid_594081 = query.getOrDefault("callback")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "callback", valid_594081
  var valid_594082 = query.getOrDefault("access_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "access_token", valid_594082
  var valid_594083 = query.getOrDefault("uploadType")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "uploadType", valid_594083
  var valid_594084 = query.getOrDefault("key")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "key", valid_594084
  var valid_594085 = query.getOrDefault("$.xgafv")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("1"))
  if valid_594085 != nil:
    section.add "$.xgafv", valid_594085
  var valid_594086 = query.getOrDefault("pageSize")
  valid_594086 = validateParameter(valid_594086, JInt, required = false, default = nil)
  if valid_594086 != nil:
    section.add "pageSize", valid_594086
  var valid_594087 = query.getOrDefault("prettyPrint")
  valid_594087 = validateParameter(valid_594087, JBool, required = false,
                                 default = newJBool(true))
  if valid_594087 != nil:
    section.add "prettyPrint", valid_594087
  var valid_594088 = query.getOrDefault("filter")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "filter", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_RuntimeconfigProjectsConfigsVariablesList_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists variables within given a configuration, matching any provided
  ## filters. This only lists variable names, not the values, unless
  ## `return_values` is true, in which case only variables that user has IAM
  ## permission to GetVariable will be returned.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_RuntimeconfigProjectsConfigsVariablesList_594070;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          returnValues: bool = false; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesList
  ## Lists variables within given a configuration, matching any provided
  ## filters. This only lists variable names, not the values, unless
  ## `return_values` is true, in which case only variables that user has IAM
  ## permission to GetVariable will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   returnValues: bool
  ##               : The flag indicates whether the user wants to return values of variables.
  ## If true, then only those variables that user has IAM GetVariable permission
  ## will be returned along with their values.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The path to the RuntimeConfig resource for which you want to list
  ## variables. The configuration must exist beforehand; the path must be in the
  ## format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Filters variables by matching the specified filter. For example:
  ## 
  ## `projects/example-project/config/[CONFIG_NAME]/variables/example-variable`.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(query_594092, "upload_protocol", newJString(uploadProtocol))
  add(query_594092, "fields", newJString(fields))
  add(query_594092, "pageToken", newJString(pageToken))
  add(query_594092, "quotaUser", newJString(quotaUser))
  add(query_594092, "alt", newJString(alt))
  add(query_594092, "returnValues", newJBool(returnValues))
  add(query_594092, "oauth_token", newJString(oauthToken))
  add(query_594092, "callback", newJString(callback))
  add(query_594092, "access_token", newJString(accessToken))
  add(query_594092, "uploadType", newJString(uploadType))
  add(path_594091, "parent", newJString(parent))
  add(query_594092, "key", newJString(key))
  add(query_594092, "$.xgafv", newJString(Xgafv))
  add(query_594092, "pageSize", newJInt(pageSize))
  add(query_594092, "prettyPrint", newJBool(prettyPrint))
  add(query_594092, "filter", newJString(filter))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesList* = Call_RuntimeconfigProjectsConfigsVariablesList_594070(
    name: "runtimeconfigProjectsConfigsVariablesList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/variables",
    validator: validate_RuntimeconfigProjectsConfigsVariablesList_594071,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesList_594072,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsWaitersCreate_594136 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsWaitersCreate_594138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/waiters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsWaitersCreate_594137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Waiter resource. This operation returns a long-running Operation
  ## resource which can be polled for completion. However, a waiter with the
  ## given name will exist (and can be retrieved) prior to the operation
  ## completing. If the operation fails, the failed Waiter resource will
  ## still exist and must be deleted prior to subsequent creation attempts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The path to the configuration that will own the waiter.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594139 = path.getOrDefault("parent")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "parent", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  var valid_594140 = query.getOrDefault("upload_protocol")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "upload_protocol", valid_594140
  var valid_594141 = query.getOrDefault("fields")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "fields", valid_594141
  var valid_594142 = query.getOrDefault("requestId")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "requestId", valid_594142
  var valid_594143 = query.getOrDefault("quotaUser")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "quotaUser", valid_594143
  var valid_594144 = query.getOrDefault("alt")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("json"))
  if valid_594144 != nil:
    section.add "alt", valid_594144
  var valid_594145 = query.getOrDefault("oauth_token")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "oauth_token", valid_594145
  var valid_594146 = query.getOrDefault("callback")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "callback", valid_594146
  var valid_594147 = query.getOrDefault("access_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "access_token", valid_594147
  var valid_594148 = query.getOrDefault("uploadType")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "uploadType", valid_594148
  var valid_594149 = query.getOrDefault("key")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "key", valid_594149
  var valid_594150 = query.getOrDefault("$.xgafv")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("1"))
  if valid_594150 != nil:
    section.add "$.xgafv", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
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

proc call*(call_594153: Call_RuntimeconfigProjectsConfigsWaitersCreate_594136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Waiter resource. This operation returns a long-running Operation
  ## resource which can be polled for completion. However, a waiter with the
  ## given name will exist (and can be retrieved) prior to the operation
  ## completing. If the operation fails, the failed Waiter resource will
  ## still exist and must be deleted prior to subsequent creation attempts.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_RuntimeconfigProjectsConfigsWaitersCreate_594136;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsWaitersCreate
  ## Creates a Waiter resource. This operation returns a long-running Operation
  ## resource which can be polled for completion. However, a waiter with the
  ## given name will exist (and can be retrieved) prior to the operation
  ## completing. If the operation fails, the failed Waiter resource will
  ## still exist and must be deleted prior to subsequent creation attempts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : An optional but recommended unique `request_id`. If the server
  ## receives two `create()` requests  with the same
  ## `request_id`, then the second request will be ignored and the
  ## first resource created and stored in the backend is returned.
  ## Empty `request_id` fields are ignored.
  ## 
  ## It is responsibility of the client to ensure uniqueness of the
  ## `request_id` strings.
  ## 
  ## `request_id` strings are limited to 64 characters.
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
  ##         : The path to the configuration that will own the waiter.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(query_594156, "upload_protocol", newJString(uploadProtocol))
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "requestId", newJString(requestId))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "callback", newJString(callback))
  add(query_594156, "access_token", newJString(accessToken))
  add(query_594156, "uploadType", newJString(uploadType))
  add(path_594155, "parent", newJString(parent))
  add(query_594156, "key", newJString(key))
  add(query_594156, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594157 = body
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var runtimeconfigProjectsConfigsWaitersCreate* = Call_RuntimeconfigProjectsConfigsWaitersCreate_594136(
    name: "runtimeconfigProjectsConfigsWaitersCreate", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/waiters",
    validator: validate_RuntimeconfigProjectsConfigsWaitersCreate_594137,
    base: "/", url: url_RuntimeconfigProjectsConfigsWaitersCreate_594138,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsWaitersList_594115 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsWaitersList_594117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/waiters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsWaitersList_594116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List waiters within the given configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The path to the configuration for which you want to get a list of waiters.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594118 = path.getOrDefault("parent")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "parent", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594119 = query.getOrDefault("upload_protocol")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "upload_protocol", valid_594119
  var valid_594120 = query.getOrDefault("fields")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "fields", valid_594120
  var valid_594121 = query.getOrDefault("pageToken")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "pageToken", valid_594121
  var valid_594122 = query.getOrDefault("quotaUser")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "quotaUser", valid_594122
  var valid_594123 = query.getOrDefault("alt")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = newJString("json"))
  if valid_594123 != nil:
    section.add "alt", valid_594123
  var valid_594124 = query.getOrDefault("oauth_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "oauth_token", valid_594124
  var valid_594125 = query.getOrDefault("callback")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "callback", valid_594125
  var valid_594126 = query.getOrDefault("access_token")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "access_token", valid_594126
  var valid_594127 = query.getOrDefault("uploadType")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "uploadType", valid_594127
  var valid_594128 = query.getOrDefault("key")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "key", valid_594128
  var valid_594129 = query.getOrDefault("$.xgafv")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("1"))
  if valid_594129 != nil:
    section.add "$.xgafv", valid_594129
  var valid_594130 = query.getOrDefault("pageSize")
  valid_594130 = validateParameter(valid_594130, JInt, required = false, default = nil)
  if valid_594130 != nil:
    section.add "pageSize", valid_594130
  var valid_594131 = query.getOrDefault("prettyPrint")
  valid_594131 = validateParameter(valid_594131, JBool, required = false,
                                 default = newJBool(true))
  if valid_594131 != nil:
    section.add "prettyPrint", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594132: Call_RuntimeconfigProjectsConfigsWaitersList_594115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List waiters within the given configuration.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_RuntimeconfigProjectsConfigsWaitersList_594115;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsWaitersList
  ## List waiters within the given configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : The path to the configuration for which you want to get a list of waiters.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  add(query_594135, "upload_protocol", newJString(uploadProtocol))
  add(query_594135, "fields", newJString(fields))
  add(query_594135, "pageToken", newJString(pageToken))
  add(query_594135, "quotaUser", newJString(quotaUser))
  add(query_594135, "alt", newJString(alt))
  add(query_594135, "oauth_token", newJString(oauthToken))
  add(query_594135, "callback", newJString(callback))
  add(query_594135, "access_token", newJString(accessToken))
  add(query_594135, "uploadType", newJString(uploadType))
  add(path_594134, "parent", newJString(parent))
  add(query_594135, "key", newJString(key))
  add(query_594135, "$.xgafv", newJString(Xgafv))
  add(query_594135, "pageSize", newJInt(pageSize))
  add(query_594135, "prettyPrint", newJBool(prettyPrint))
  result = call_594133.call(path_594134, query_594135, nil, nil, nil)

var runtimeconfigProjectsConfigsWaitersList* = Call_RuntimeconfigProjectsConfigsWaitersList_594115(
    name: "runtimeconfigProjectsConfigsWaitersList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/waiters",
    validator: validate_RuntimeconfigProjectsConfigsWaitersList_594116, base: "/",
    url: url_RuntimeconfigProjectsConfigsWaitersList_594117,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsGetIamPolicy_594158 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsGetIamPolicy_594160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsGetIamPolicy_594159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594161 = path.getOrDefault("resource")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resource", valid_594161
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594162 = query.getOrDefault("upload_protocol")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "upload_protocol", valid_594162
  var valid_594163 = query.getOrDefault("fields")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "fields", valid_594163
  var valid_594164 = query.getOrDefault("quotaUser")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "quotaUser", valid_594164
  var valid_594165 = query.getOrDefault("alt")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = newJString("json"))
  if valid_594165 != nil:
    section.add "alt", valid_594165
  var valid_594166 = query.getOrDefault("oauth_token")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "oauth_token", valid_594166
  var valid_594167 = query.getOrDefault("callback")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "callback", valid_594167
  var valid_594168 = query.getOrDefault("access_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "access_token", valid_594168
  var valid_594169 = query.getOrDefault("uploadType")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "uploadType", valid_594169
  var valid_594170 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594170 = validateParameter(valid_594170, JInt, required = false, default = nil)
  if valid_594170 != nil:
    section.add "options.requestedPolicyVersion", valid_594170
  var valid_594171 = query.getOrDefault("key")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "key", valid_594171
  var valid_594172 = query.getOrDefault("$.xgafv")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("1"))
  if valid_594172 != nil:
    section.add "$.xgafv", valid_594172
  var valid_594173 = query.getOrDefault("prettyPrint")
  valid_594173 = validateParameter(valid_594173, JBool, required = false,
                                 default = newJBool(true))
  if valid_594173 != nil:
    section.add "prettyPrint", valid_594173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594174: Call_RuntimeconfigProjectsConfigsGetIamPolicy_594158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_RuntimeconfigProjectsConfigsGetIamPolicy_594158;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  add(query_594177, "upload_protocol", newJString(uploadProtocol))
  add(query_594177, "fields", newJString(fields))
  add(query_594177, "quotaUser", newJString(quotaUser))
  add(query_594177, "alt", newJString(alt))
  add(query_594177, "oauth_token", newJString(oauthToken))
  add(query_594177, "callback", newJString(callback))
  add(query_594177, "access_token", newJString(accessToken))
  add(query_594177, "uploadType", newJString(uploadType))
  add(query_594177, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594177, "key", newJString(key))
  add(query_594177, "$.xgafv", newJString(Xgafv))
  add(path_594176, "resource", newJString(resource))
  add(query_594177, "prettyPrint", newJBool(prettyPrint))
  result = call_594175.call(path_594176, query_594177, nil, nil, nil)

var runtimeconfigProjectsConfigsGetIamPolicy* = Call_RuntimeconfigProjectsConfigsGetIamPolicy_594158(
    name: "runtimeconfigProjectsConfigsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_RuntimeconfigProjectsConfigsGetIamPolicy_594159,
    base: "/", url: url_RuntimeconfigProjectsConfigsGetIamPolicy_594160,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsSetIamPolicy_594178 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsSetIamPolicy_594180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsSetIamPolicy_594179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
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
  var valid_594181 = path.getOrDefault("resource")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "resource", valid_594181
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
  var valid_594182 = query.getOrDefault("upload_protocol")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "upload_protocol", valid_594182
  var valid_594183 = query.getOrDefault("fields")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "fields", valid_594183
  var valid_594184 = query.getOrDefault("quotaUser")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "quotaUser", valid_594184
  var valid_594185 = query.getOrDefault("alt")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = newJString("json"))
  if valid_594185 != nil:
    section.add "alt", valid_594185
  var valid_594186 = query.getOrDefault("oauth_token")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "oauth_token", valid_594186
  var valid_594187 = query.getOrDefault("callback")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "callback", valid_594187
  var valid_594188 = query.getOrDefault("access_token")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "access_token", valid_594188
  var valid_594189 = query.getOrDefault("uploadType")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "uploadType", valid_594189
  var valid_594190 = query.getOrDefault("key")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "key", valid_594190
  var valid_594191 = query.getOrDefault("$.xgafv")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("1"))
  if valid_594191 != nil:
    section.add "$.xgafv", valid_594191
  var valid_594192 = query.getOrDefault("prettyPrint")
  valid_594192 = validateParameter(valid_594192, JBool, required = false,
                                 default = newJBool(true))
  if valid_594192 != nil:
    section.add "prettyPrint", valid_594192
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

proc call*(call_594194: Call_RuntimeconfigProjectsConfigsSetIamPolicy_594178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_RuntimeconfigProjectsConfigsSetIamPolicy_594178;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
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
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  var body_594198 = newJObject()
  add(query_594197, "upload_protocol", newJString(uploadProtocol))
  add(query_594197, "fields", newJString(fields))
  add(query_594197, "quotaUser", newJString(quotaUser))
  add(query_594197, "alt", newJString(alt))
  add(query_594197, "oauth_token", newJString(oauthToken))
  add(query_594197, "callback", newJString(callback))
  add(query_594197, "access_token", newJString(accessToken))
  add(query_594197, "uploadType", newJString(uploadType))
  add(query_594197, "key", newJString(key))
  add(query_594197, "$.xgafv", newJString(Xgafv))
  add(path_594196, "resource", newJString(resource))
  if body != nil:
    body_594198 = body
  add(query_594197, "prettyPrint", newJBool(prettyPrint))
  result = call_594195.call(path_594196, query_594197, nil, nil, body_594198)

var runtimeconfigProjectsConfigsSetIamPolicy* = Call_RuntimeconfigProjectsConfigsSetIamPolicy_594178(
    name: "runtimeconfigProjectsConfigsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_RuntimeconfigProjectsConfigsSetIamPolicy_594179,
    base: "/", url: url_RuntimeconfigProjectsConfigsSetIamPolicy_594180,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594199 = ref object of OpenApiRestCall_593408
proc url_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594201(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594202 = path.getOrDefault("resource")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "resource", valid_594202
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

proc call*(call_594215: Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594199;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runtimeconfigProjectsConfigsVariablesTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  add(query_594218, "key", newJString(key))
  add(query_594218, "$.xgafv", newJString(Xgafv))
  add(path_594217, "resource", newJString(resource))
  if body != nil:
    body_594219 = body
  add(query_594218, "prettyPrint", newJBool(prettyPrint))
  result = call_594216.call(path_594217, query_594218, nil, nil, body_594219)

var runtimeconfigProjectsConfigsVariablesTestIamPermissions* = Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594199(
    name: "runtimeconfigProjectsConfigsVariablesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions", validator: validate_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594200,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_594201,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
