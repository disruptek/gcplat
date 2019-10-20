
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "runtimeconfig"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RuntimeconfigProjectsConfigsVariablesUpdate_578898 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesUpdate_578900(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesUpdate_578899(path: JsonNode;
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
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

proc call*(call_578914: Call_RuntimeconfigProjectsConfigsVariablesUpdate_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing variable with a new value.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_RuntimeconfigProjectsConfigsVariablesUpdate_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesUpdate
  ## Updates an existing variable with a new value.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to update, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  var body_578918 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(path_578916, "name", newJString(name))
  if body != nil:
    body_578918 = body
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578915.call(path_578916, query_578917, nil, nil, body_578918)

var runtimeconfigProjectsConfigsVariablesUpdate* = Call_RuntimeconfigProjectsConfigsVariablesUpdate_578898(
    name: "runtimeconfigProjectsConfigsVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesUpdate_578899,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesUpdate_578900,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesGet_578610 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesGet_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesGet_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_RuntimeconfigProjectsConfigsVariablesGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a single variable.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_RuntimeconfigProjectsConfigsVariablesGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesGet
  ## Gets information about a single variable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to return, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIBLE_NAME]`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesGet* = Call_RuntimeconfigProjectsConfigsVariablesGet_578610(
    name: "runtimeconfigProjectsConfigsVariablesGet", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesGet_578611,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesGet_578612,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesDelete_578919 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesDelete_578921(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeconfigProjectsConfigsVariablesDelete_578920(path: JsonNode;
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
  var valid_578922 = path.getOrDefault("name")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "name", valid_578922
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   recursive: JBool
  ##            : Set to `true` to recursively delete multiple variables with the same
  ## prefix.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("$.xgafv")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("1"))
  if valid_578926 != nil:
    section.add "$.xgafv", valid_578926
  var valid_578927 = query.getOrDefault("recursive")
  valid_578927 = validateParameter(valid_578927, JBool, required = false, default = nil)
  if valid_578927 != nil:
    section.add "recursive", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("uploadType")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "uploadType", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("callback")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "callback", valid_578931
  var valid_578932 = query.getOrDefault("fields")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "fields", valid_578932
  var valid_578933 = query.getOrDefault("access_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "access_token", valid_578933
  var valid_578934 = query.getOrDefault("upload_protocol")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "upload_protocol", valid_578934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578935: Call_RuntimeconfigProjectsConfigsVariablesDelete_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a variable or multiple variables.
  ## 
  ## If you specify a variable name, then that variable is deleted. If you
  ## specify a prefix and `recursive` is true, then all variables with that
  ## prefix are deleted. You must set a `recursive` to true if you delete
  ## variables by prefix.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_RuntimeconfigProjectsConfigsVariablesDelete_578919;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; recursive: bool = false;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesDelete
  ## Deletes a variable or multiple variables.
  ## 
  ## If you specify a variable name, then that variable is deleted. If you
  ## specify a prefix and `recursive` is true, then all variables with that
  ## prefix are deleted. You must set a `recursive` to true if you delete
  ## variables by prefix.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   recursive: bool
  ##            : Set to `true` to recursively delete multiple variables with the same
  ## prefix.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to delete, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]/variables/[VARIABLE_NAME]`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "$.xgafv", newJString(Xgafv))
  add(query_578938, "recursive", newJBool(recursive))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "uploadType", newJString(uploadType))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "name", newJString(name))
  add(query_578938, "callback", newJString(callback))
  add(query_578938, "fields", newJString(fields))
  add(query_578938, "access_token", newJString(accessToken))
  add(query_578938, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(path_578937, query_578938, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesDelete* = Call_RuntimeconfigProjectsConfigsVariablesDelete_578919(
    name: "runtimeconfigProjectsConfigsVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_RuntimeconfigProjectsConfigsVariablesDelete_578920,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesDelete_578921,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesWatch_578939 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesWatch_578941(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsVariablesWatch_578940(path: JsonNode;
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
  var valid_578942 = path.getOrDefault("name")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "name", valid_578942
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578943 = query.getOrDefault("key")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "key", valid_578943
  var valid_578944 = query.getOrDefault("prettyPrint")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(true))
  if valid_578944 != nil:
    section.add "prettyPrint", valid_578944
  var valid_578945 = query.getOrDefault("oauth_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "oauth_token", valid_578945
  var valid_578946 = query.getOrDefault("$.xgafv")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("1"))
  if valid_578946 != nil:
    section.add "$.xgafv", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("uploadType")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "uploadType", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("callback")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "callback", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  var valid_578952 = query.getOrDefault("access_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "access_token", valid_578952
  var valid_578953 = query.getOrDefault("upload_protocol")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "upload_protocol", valid_578953
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

proc call*(call_578955: Call_RuntimeconfigProjectsConfigsVariablesWatch_578939;
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
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_RuntimeconfigProjectsConfigsVariablesWatch_578939;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the variable to watch, in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  var body_578959 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "$.xgafv", newJString(Xgafv))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "uploadType", newJString(uploadType))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "name", newJString(name))
  if body != nil:
    body_578959 = body
  add(query_578958, "callback", newJString(callback))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, body_578959)

var runtimeconfigProjectsConfigsVariablesWatch* = Call_RuntimeconfigProjectsConfigsVariablesWatch_578939(
    name: "runtimeconfigProjectsConfigsVariablesWatch", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{name}:watch",
    validator: validate_RuntimeconfigProjectsConfigsVariablesWatch_578940,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesWatch_578941,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsCreate_578981 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsCreate_578983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsCreate_578982(path: JsonNode;
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
  var valid_578984 = path.getOrDefault("parent")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "parent", valid_578984
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578985 = query.getOrDefault("key")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "key", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("$.xgafv")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("1"))
  if valid_578988 != nil:
    section.add "$.xgafv", valid_578988
  var valid_578989 = query.getOrDefault("alt")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = newJString("json"))
  if valid_578989 != nil:
    section.add "alt", valid_578989
  var valid_578990 = query.getOrDefault("uploadType")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "uploadType", valid_578990
  var valid_578991 = query.getOrDefault("quotaUser")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "quotaUser", valid_578991
  var valid_578992 = query.getOrDefault("callback")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "callback", valid_578992
  var valid_578993 = query.getOrDefault("requestId")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "requestId", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  var valid_578995 = query.getOrDefault("access_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "access_token", valid_578995
  var valid_578996 = query.getOrDefault("upload_protocol")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "upload_protocol", valid_578996
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

proc call*(call_578998: Call_RuntimeconfigProjectsConfigsCreate_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new RuntimeConfig resource. The configuration name must be
  ## unique within project.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_RuntimeconfigProjectsConfigsCreate_578981;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; requestId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsCreate
  ## Creates a new RuntimeConfig resource. The configuration name must be
  ## unique within project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  var body_579002 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "$.xgafv", newJString(Xgafv))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "uploadType", newJString(uploadType))
  add(query_579001, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579002 = body
  add(query_579001, "callback", newJString(callback))
  add(path_579000, "parent", newJString(parent))
  add(query_579001, "requestId", newJString(requestId))
  add(query_579001, "fields", newJString(fields))
  add(query_579001, "access_token", newJString(accessToken))
  add(query_579001, "upload_protocol", newJString(uploadProtocol))
  result = call_578999.call(path_579000, query_579001, nil, nil, body_579002)

var runtimeconfigProjectsConfigsCreate* = Call_RuntimeconfigProjectsConfigsCreate_578981(
    name: "runtimeconfigProjectsConfigsCreate", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/configs",
    validator: validate_RuntimeconfigProjectsConfigsCreate_578982, base: "/",
    url: url_RuntimeconfigProjectsConfigsCreate_578983, schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsList_578960 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsList_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsList_578961(path: JsonNode;
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
  var valid_578963 = path.getOrDefault("parent")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "parent", valid_578963
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("pageSize")
  valid_578968 = validateParameter(valid_578968, JInt, required = false, default = nil)
  if valid_578968 != nil:
    section.add "pageSize", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("uploadType")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "uploadType", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("pageToken")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "pageToken", valid_578972
  var valid_578973 = query.getOrDefault("callback")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "callback", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  var valid_578975 = query.getOrDefault("access_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "access_token", valid_578975
  var valid_578976 = query.getOrDefault("upload_protocol")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "upload_protocol", valid_578976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578977: Call_RuntimeconfigProjectsConfigsList_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the RuntimeConfig resources within project.
  ## 
  let valid = call_578977.validator(path, query, header, formData, body)
  let scheme = call_578977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578977.url(scheme.get, call_578977.host, call_578977.base,
                         call_578977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578977, url, valid)

proc call*(call_578978: Call_RuntimeconfigProjectsConfigsList_578960;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsList
  ## Lists all the RuntimeConfig resources within project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The [project
  ## ID](https://support.google.com/cloud/answer/6158840?hl=en&ref_topic=6158848)
  ## for this request, in the format `projects/[PROJECT_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578979 = newJObject()
  var query_578980 = newJObject()
  add(query_578980, "key", newJString(key))
  add(query_578980, "prettyPrint", newJBool(prettyPrint))
  add(query_578980, "oauth_token", newJString(oauthToken))
  add(query_578980, "$.xgafv", newJString(Xgafv))
  add(query_578980, "pageSize", newJInt(pageSize))
  add(query_578980, "alt", newJString(alt))
  add(query_578980, "uploadType", newJString(uploadType))
  add(query_578980, "quotaUser", newJString(quotaUser))
  add(query_578980, "pageToken", newJString(pageToken))
  add(query_578980, "callback", newJString(callback))
  add(path_578979, "parent", newJString(parent))
  add(query_578980, "fields", newJString(fields))
  add(query_578980, "access_token", newJString(accessToken))
  add(query_578980, "upload_protocol", newJString(uploadProtocol))
  result = call_578978.call(path_578979, query_578980, nil, nil, nil)

var runtimeconfigProjectsConfigsList* = Call_RuntimeconfigProjectsConfigsList_578960(
    name: "runtimeconfigProjectsConfigsList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/configs",
    validator: validate_RuntimeconfigProjectsConfigsList_578961, base: "/",
    url: url_RuntimeconfigProjectsConfigsList_578962, schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesCreate_579026 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesCreate_579028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsVariablesCreate_579027(path: JsonNode;
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
  var valid_579029 = path.getOrDefault("parent")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "parent", valid_579029
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579030 = query.getOrDefault("key")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "key", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("$.xgafv")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("1"))
  if valid_579033 != nil:
    section.add "$.xgafv", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("uploadType")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "uploadType", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("callback")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "callback", valid_579037
  var valid_579038 = query.getOrDefault("requestId")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "requestId", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
  var valid_579040 = query.getOrDefault("access_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "access_token", valid_579040
  var valid_579041 = query.getOrDefault("upload_protocol")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "upload_protocol", valid_579041
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

proc call*(call_579043: Call_RuntimeconfigProjectsConfigsVariablesCreate_579026;
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
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_RuntimeconfigProjectsConfigsVariablesCreate_579026;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; requestId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesCreate
  ## Creates a variable within the given configuration. You cannot create
  ## a variable with a name that is a prefix of an existing variable name, or a
  ## name that has an existing variable name as a prefix.
  ## 
  ## To learn more about creating a variable, read the
  ## [Setting and Getting
  ## Data](/deployment-manager/runtime-configurator/set-and-get-variables)
  ## documentation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The path to the RutimeConfig resource that this variable should belong to.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "$.xgafv", newJString(Xgafv))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "uploadType", newJString(uploadType))
  add(query_579046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579047 = body
  add(query_579046, "callback", newJString(callback))
  add(path_579045, "parent", newJString(parent))
  add(query_579046, "requestId", newJString(requestId))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "access_token", newJString(accessToken))
  add(query_579046, "upload_protocol", newJString(uploadProtocol))
  result = call_579044.call(path_579045, query_579046, nil, nil, body_579047)

var runtimeconfigProjectsConfigsVariablesCreate* = Call_RuntimeconfigProjectsConfigsVariablesCreate_579026(
    name: "runtimeconfigProjectsConfigsVariablesCreate",
    meth: HttpMethod.HttpPost, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{parent}/variables",
    validator: validate_RuntimeconfigProjectsConfigsVariablesCreate_579027,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesCreate_579028,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesList_579003 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesList_579005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsVariablesList_579004(path: JsonNode;
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
  var valid_579006 = path.getOrDefault("parent")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "parent", valid_579006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   returnValues: JBool
  ##               : The flag indicates whether the user wants to return values of variables.
  ## If true, then only those variables that user has IAM GetVariable permission
  ## will be returned along with their values.
  ##   pageSize: JInt
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Filters variables by matching the specified filter. For example:
  ## 
  ## `projects/example-project/config/[CONFIG_NAME]/variables/example-variable`.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("returnValues")
  valid_579011 = validateParameter(valid_579011, JBool, required = false, default = nil)
  if valid_579011 != nil:
    section.add "returnValues", valid_579011
  var valid_579012 = query.getOrDefault("pageSize")
  valid_579012 = validateParameter(valid_579012, JInt, required = false, default = nil)
  if valid_579012 != nil:
    section.add "pageSize", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("uploadType")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "uploadType", valid_579014
  var valid_579015 = query.getOrDefault("quotaUser")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "quotaUser", valid_579015
  var valid_579016 = query.getOrDefault("filter")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "filter", valid_579016
  var valid_579017 = query.getOrDefault("pageToken")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "pageToken", valid_579017
  var valid_579018 = query.getOrDefault("callback")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "callback", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  var valid_579020 = query.getOrDefault("access_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "access_token", valid_579020
  var valid_579021 = query.getOrDefault("upload_protocol")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "upload_protocol", valid_579021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579022: Call_RuntimeconfigProjectsConfigsVariablesList_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists variables within given a configuration, matching any provided
  ## filters. This only lists variable names, not the values, unless
  ## `return_values` is true, in which case only variables that user has IAM
  ## permission to GetVariable will be returned.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_RuntimeconfigProjectsConfigsVariablesList_579003;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; returnValues: bool = false;
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesList
  ## Lists variables within given a configuration, matching any provided
  ## filters. This only lists variable names, not the values, unless
  ## `return_values` is true, in which case only variables that user has IAM
  ## permission to GetVariable will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   returnValues: bool
  ##               : The flag indicates whether the user wants to return values of variables.
  ## If true, then only those variables that user has IAM GetVariable permission
  ## will be returned along with their values.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Filters variables by matching the specified filter. For example:
  ## 
  ## `projects/example-project/config/[CONFIG_NAME]/variables/example-variable`.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The path to the RuntimeConfig resource for which you want to list
  ## variables. The configuration must exist beforehand; the path must be in the
  ## format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "$.xgafv", newJString(Xgafv))
  add(query_579025, "returnValues", newJBool(returnValues))
  add(query_579025, "pageSize", newJInt(pageSize))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "uploadType", newJString(uploadType))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(query_579025, "filter", newJString(filter))
  add(query_579025, "pageToken", newJString(pageToken))
  add(query_579025, "callback", newJString(callback))
  add(path_579024, "parent", newJString(parent))
  add(query_579025, "fields", newJString(fields))
  add(query_579025, "access_token", newJString(accessToken))
  add(query_579025, "upload_protocol", newJString(uploadProtocol))
  result = call_579023.call(path_579024, query_579025, nil, nil, nil)

var runtimeconfigProjectsConfigsVariablesList* = Call_RuntimeconfigProjectsConfigsVariablesList_579003(
    name: "runtimeconfigProjectsConfigsVariablesList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/variables",
    validator: validate_RuntimeconfigProjectsConfigsVariablesList_579004,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesList_579005,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsWaitersCreate_579069 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsWaitersCreate_579071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsWaitersCreate_579070(path: JsonNode;
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
  var valid_579072 = path.getOrDefault("parent")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "parent", valid_579072
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("uploadType")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "uploadType", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("callback")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "callback", valid_579080
  var valid_579081 = query.getOrDefault("requestId")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "requestId", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("access_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "access_token", valid_579083
  var valid_579084 = query.getOrDefault("upload_protocol")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "upload_protocol", valid_579084
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

proc call*(call_579086: Call_RuntimeconfigProjectsConfigsWaitersCreate_579069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Waiter resource. This operation returns a long-running Operation
  ## resource which can be polled for completion. However, a waiter with the
  ## given name will exist (and can be retrieved) prior to the operation
  ## completing. If the operation fails, the failed Waiter resource will
  ## still exist and must be deleted prior to subsequent creation attempts.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_RuntimeconfigProjectsConfigsWaitersCreate_579069;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; requestId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsWaitersCreate
  ## Creates a Waiter resource. This operation returns a long-running Operation
  ## resource which can be polled for completion. However, a waiter with the
  ## given name will exist (and can be retrieved) prior to the operation
  ## completing. If the operation fails, the failed Waiter resource will
  ## still exist and must be deleted prior to subsequent creation attempts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The path to the configuration that will own the waiter.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  var body_579090 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(query_579089, "$.xgafv", newJString(Xgafv))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "uploadType", newJString(uploadType))
  add(query_579089, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579090 = body
  add(query_579089, "callback", newJString(callback))
  add(path_579088, "parent", newJString(parent))
  add(query_579089, "requestId", newJString(requestId))
  add(query_579089, "fields", newJString(fields))
  add(query_579089, "access_token", newJString(accessToken))
  add(query_579089, "upload_protocol", newJString(uploadProtocol))
  result = call_579087.call(path_579088, query_579089, nil, nil, body_579090)

var runtimeconfigProjectsConfigsWaitersCreate* = Call_RuntimeconfigProjectsConfigsWaitersCreate_579069(
    name: "runtimeconfigProjectsConfigsWaitersCreate", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/waiters",
    validator: validate_RuntimeconfigProjectsConfigsWaitersCreate_579070,
    base: "/", url: url_RuntimeconfigProjectsConfigsWaitersCreate_579071,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsWaitersList_579048 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsWaitersList_579050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsWaitersList_579049(path: JsonNode;
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
  var valid_579051 = path.getOrDefault("parent")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "parent", valid_579051
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("$.xgafv")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("1"))
  if valid_579055 != nil:
    section.add "$.xgafv", valid_579055
  var valid_579056 = query.getOrDefault("pageSize")
  valid_579056 = validateParameter(valid_579056, JInt, required = false, default = nil)
  if valid_579056 != nil:
    section.add "pageSize", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("pageToken")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "pageToken", valid_579060
  var valid_579061 = query.getOrDefault("callback")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "callback", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
  var valid_579063 = query.getOrDefault("access_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "access_token", valid_579063
  var valid_579064 = query.getOrDefault("upload_protocol")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "upload_protocol", valid_579064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579065: Call_RuntimeconfigProjectsConfigsWaitersList_579048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List waiters within the given configuration.
  ## 
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_RuntimeconfigProjectsConfigsWaitersList_579048;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsWaitersList
  ## List waiters within the given configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The path to the configuration for which you want to get a list of waiters.
  ## The configuration must exist beforehand; the path must be in the format:
  ## 
  ## `projects/[PROJECT_ID]/configs/[CONFIG_NAME]`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "$.xgafv", newJString(Xgafv))
  add(query_579068, "pageSize", newJInt(pageSize))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "uploadType", newJString(uploadType))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(query_579068, "pageToken", newJString(pageToken))
  add(query_579068, "callback", newJString(callback))
  add(path_579067, "parent", newJString(parent))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "access_token", newJString(accessToken))
  add(query_579068, "upload_protocol", newJString(uploadProtocol))
  result = call_579066.call(path_579067, query_579068, nil, nil, nil)

var runtimeconfigProjectsConfigsWaitersList* = Call_RuntimeconfigProjectsConfigsWaitersList_579048(
    name: "runtimeconfigProjectsConfigsWaitersList", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com", route: "/v1beta1/{parent}/waiters",
    validator: validate_RuntimeconfigProjectsConfigsWaitersList_579049, base: "/",
    url: url_RuntimeconfigProjectsConfigsWaitersList_579050,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsGetIamPolicy_579091 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsGetIamPolicy_579093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsGetIamPolicy_579092(path: JsonNode;
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
  var valid_579094 = path.getOrDefault("resource")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "resource", valid_579094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("$.xgafv")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("1"))
  if valid_579098 != nil:
    section.add "$.xgafv", valid_579098
  var valid_579099 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579099 = validateParameter(valid_579099, JInt, required = false, default = nil)
  if valid_579099 != nil:
    section.add "options.requestedPolicyVersion", valid_579099
  var valid_579100 = query.getOrDefault("alt")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("json"))
  if valid_579100 != nil:
    section.add "alt", valid_579100
  var valid_579101 = query.getOrDefault("uploadType")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "uploadType", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("callback")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "callback", valid_579103
  var valid_579104 = query.getOrDefault("fields")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "fields", valid_579104
  var valid_579105 = query.getOrDefault("access_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "access_token", valid_579105
  var valid_579106 = query.getOrDefault("upload_protocol")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "upload_protocol", valid_579106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579107: Call_RuntimeconfigProjectsConfigsGetIamPolicy_579091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579107.validator(path, query, header, formData, body)
  let scheme = call_579107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579107.url(scheme.get, call_579107.host, call_579107.base,
                         call_579107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579107, url, valid)

proc call*(call_579108: Call_RuntimeconfigProjectsConfigsGetIamPolicy_579091;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579109 = newJObject()
  var query_579110 = newJObject()
  add(query_579110, "key", newJString(key))
  add(query_579110, "prettyPrint", newJBool(prettyPrint))
  add(query_579110, "oauth_token", newJString(oauthToken))
  add(query_579110, "$.xgafv", newJString(Xgafv))
  add(query_579110, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579110, "alt", newJString(alt))
  add(query_579110, "uploadType", newJString(uploadType))
  add(query_579110, "quotaUser", newJString(quotaUser))
  add(path_579109, "resource", newJString(resource))
  add(query_579110, "callback", newJString(callback))
  add(query_579110, "fields", newJString(fields))
  add(query_579110, "access_token", newJString(accessToken))
  add(query_579110, "upload_protocol", newJString(uploadProtocol))
  result = call_579108.call(path_579109, query_579110, nil, nil, nil)

var runtimeconfigProjectsConfigsGetIamPolicy* = Call_RuntimeconfigProjectsConfigsGetIamPolicy_579091(
    name: "runtimeconfigProjectsConfigsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_RuntimeconfigProjectsConfigsGetIamPolicy_579092,
    base: "/", url: url_RuntimeconfigProjectsConfigsGetIamPolicy_579093,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsSetIamPolicy_579111 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsSetIamPolicy_579113(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsSetIamPolicy_579112(path: JsonNode;
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
  var valid_579114 = path.getOrDefault("resource")
  valid_579114 = validateParameter(valid_579114, JString, required = true,
                                 default = nil)
  if valid_579114 != nil:
    section.add "resource", valid_579114
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579115 = query.getOrDefault("key")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "key", valid_579115
  var valid_579116 = query.getOrDefault("prettyPrint")
  valid_579116 = validateParameter(valid_579116, JBool, required = false,
                                 default = newJBool(true))
  if valid_579116 != nil:
    section.add "prettyPrint", valid_579116
  var valid_579117 = query.getOrDefault("oauth_token")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "oauth_token", valid_579117
  var valid_579118 = query.getOrDefault("$.xgafv")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("1"))
  if valid_579118 != nil:
    section.add "$.xgafv", valid_579118
  var valid_579119 = query.getOrDefault("alt")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = newJString("json"))
  if valid_579119 != nil:
    section.add "alt", valid_579119
  var valid_579120 = query.getOrDefault("uploadType")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "uploadType", valid_579120
  var valid_579121 = query.getOrDefault("quotaUser")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "quotaUser", valid_579121
  var valid_579122 = query.getOrDefault("callback")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "callback", valid_579122
  var valid_579123 = query.getOrDefault("fields")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "fields", valid_579123
  var valid_579124 = query.getOrDefault("access_token")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "access_token", valid_579124
  var valid_579125 = query.getOrDefault("upload_protocol")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "upload_protocol", valid_579125
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

proc call*(call_579127: Call_RuntimeconfigProjectsConfigsSetIamPolicy_579111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579127.validator(path, query, header, formData, body)
  let scheme = call_579127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579127.url(scheme.get, call_579127.host, call_579127.base,
                         call_579127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579127, url, valid)

proc call*(call_579128: Call_RuntimeconfigProjectsConfigsSetIamPolicy_579111;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579129 = newJObject()
  var query_579130 = newJObject()
  var body_579131 = newJObject()
  add(query_579130, "key", newJString(key))
  add(query_579130, "prettyPrint", newJBool(prettyPrint))
  add(query_579130, "oauth_token", newJString(oauthToken))
  add(query_579130, "$.xgafv", newJString(Xgafv))
  add(query_579130, "alt", newJString(alt))
  add(query_579130, "uploadType", newJString(uploadType))
  add(query_579130, "quotaUser", newJString(quotaUser))
  add(path_579129, "resource", newJString(resource))
  if body != nil:
    body_579131 = body
  add(query_579130, "callback", newJString(callback))
  add(query_579130, "fields", newJString(fields))
  add(query_579130, "access_token", newJString(accessToken))
  add(query_579130, "upload_protocol", newJString(uploadProtocol))
  result = call_579128.call(path_579129, query_579130, nil, nil, body_579131)

var runtimeconfigProjectsConfigsSetIamPolicy* = Call_RuntimeconfigProjectsConfigsSetIamPolicy_579111(
    name: "runtimeconfigProjectsConfigsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_RuntimeconfigProjectsConfigsSetIamPolicy_579112,
    base: "/", url: url_RuntimeconfigProjectsConfigsSetIamPolicy_579113,
    schemes: {Scheme.Https})
type
  Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579132 = ref object of OpenApiRestCall_578339
proc url_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579134(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579133(
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
  var valid_579135 = path.getOrDefault("resource")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "resource", valid_579135
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579136 = query.getOrDefault("key")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "key", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("$.xgafv")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("1"))
  if valid_579139 != nil:
    section.add "$.xgafv", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("uploadType")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "uploadType", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("callback")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "callback", valid_579143
  var valid_579144 = query.getOrDefault("fields")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "fields", valid_579144
  var valid_579145 = query.getOrDefault("access_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "access_token", valid_579145
  var valid_579146 = query.getOrDefault("upload_protocol")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "upload_protocol", valid_579146
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

proc call*(call_579148: Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579132;
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
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579132;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runtimeconfigProjectsConfigsVariablesTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579150 = newJObject()
  var query_579151 = newJObject()
  var body_579152 = newJObject()
  add(query_579151, "key", newJString(key))
  add(query_579151, "prettyPrint", newJBool(prettyPrint))
  add(query_579151, "oauth_token", newJString(oauthToken))
  add(query_579151, "$.xgafv", newJString(Xgafv))
  add(query_579151, "alt", newJString(alt))
  add(query_579151, "uploadType", newJString(uploadType))
  add(query_579151, "quotaUser", newJString(quotaUser))
  add(path_579150, "resource", newJString(resource))
  if body != nil:
    body_579152 = body
  add(query_579151, "callback", newJString(callback))
  add(query_579151, "fields", newJString(fields))
  add(query_579151, "access_token", newJString(accessToken))
  add(query_579151, "upload_protocol", newJString(uploadProtocol))
  result = call_579149.call(path_579150, query_579151, nil, nil, body_579152)

var runtimeconfigProjectsConfigsVariablesTestIamPermissions* = Call_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579132(
    name: "runtimeconfigProjectsConfigsVariablesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "runtimeconfig.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions", validator: validate_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579133,
    base: "/", url: url_RuntimeconfigProjectsConfigsVariablesTestIamPermissions_579134,
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
