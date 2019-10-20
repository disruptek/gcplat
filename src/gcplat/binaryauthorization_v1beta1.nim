
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Binary Authorization
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The management interface for Binary Authorization, a system providing policy control for images deployed to Kubernetes Engine clusters.
## 
## 
## https://cloud.google.com/binary-authorization/
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
  gcpServiceName = "binaryauthorization"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BinaryauthorizationProjectsAttestorsUpdate_578898 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsUpdate_578900(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsUpdate_578899(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name, in the format:
  ## `projects/*/attestors/*`. This field may not be updated.
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

proc call*(call_578914: Call_BinaryauthorizationProjectsAttestorsUpdate_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_BinaryauthorizationProjectsAttestorsUpdate_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsUpdate
  ## Updates an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
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
  ##       : Required. The resource name, in the format:
  ## `projects/*/attestors/*`. This field may not be updated.
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

var binaryauthorizationProjectsAttestorsUpdate* = Call_BinaryauthorizationProjectsAttestorsUpdate_578898(
    name: "binaryauthorizationProjectsAttestorsUpdate", meth: HttpMethod.HttpPut,
    host: "binaryauthorization.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsUpdate_578899,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsUpdate_578900,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsGet_578610 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsGet_578612(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsGet_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the attestor to retrieve, in the format
  ## `projects/*/attestors/*`.
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

proc call*(call_578785: Call_BinaryauthorizationProjectsAttestorsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_BinaryauthorizationProjectsAttestorsGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsGet
  ## Gets an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
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
  ##       : Required. The name of the attestor to retrieve, in the format
  ## `projects/*/attestors/*`.
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

var binaryauthorizationProjectsAttestorsGet* = Call_BinaryauthorizationProjectsAttestorsGet_578610(
    name: "binaryauthorizationProjectsAttestorsGet", meth: HttpMethod.HttpGet,
    host: "binaryauthorization.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsGet_578611, base: "/",
    url: url_BinaryauthorizationProjectsAttestorsGet_578612,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsDelete_578919 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsDelete_578921(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsDelete_578920(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an attestor. Returns NOT_FOUND if the
  ## attestor does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the attestors to delete, in the format
  ## `projects/*/attestors/*`.
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
  var valid_578927 = query.getOrDefault("alt")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("json"))
  if valid_578927 != nil:
    section.add "alt", valid_578927
  var valid_578928 = query.getOrDefault("uploadType")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "uploadType", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578934: Call_BinaryauthorizationProjectsAttestorsDelete_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an attestor. Returns NOT_FOUND if the
  ## attestor does not exist.
  ## 
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_BinaryauthorizationProjectsAttestorsDelete_578919;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsDelete
  ## Deletes an attestor. Returns NOT_FOUND if the
  ## attestor does not exist.
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
  ##       : Required. The name of the attestors to delete, in the format
  ## `projects/*/attestors/*`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578936 = newJObject()
  var query_578937 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(path_578936, "name", newJString(name))
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578935.call(path_578936, query_578937, nil, nil, nil)

var binaryauthorizationProjectsAttestorsDelete* = Call_BinaryauthorizationProjectsAttestorsDelete_578919(
    name: "binaryauthorizationProjectsAttestorsDelete",
    meth: HttpMethod.HttpDelete, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsDelete_578920,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsDelete_578921,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsCreate_578959 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsCreate_578961(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/attestors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsCreate_578960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an attestor, and returns a copy of the new
  ## attestor. Returns NOT_FOUND if the project does not exist,
  ## INVALID_ARGUMENT if the request is malformed, ALREADY_EXISTS if the
  ## attestor already exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent of this attestor.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578962 = path.getOrDefault("parent")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "parent", valid_578962
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
  ##   attestorId: JString
  ##             : Required. The attestors ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("$.xgafv")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("1"))
  if valid_578966 != nil:
    section.add "$.xgafv", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("uploadType")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "uploadType", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("attestorId")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "attestorId", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("access_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "access_token", valid_578973
  var valid_578974 = query.getOrDefault("upload_protocol")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "upload_protocol", valid_578974
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

proc call*(call_578976: Call_BinaryauthorizationProjectsAttestorsCreate_578959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an attestor, and returns a copy of the new
  ## attestor. Returns NOT_FOUND if the project does not exist,
  ## INVALID_ARGUMENT if the request is malformed, ALREADY_EXISTS if the
  ## attestor already exists.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_BinaryauthorizationProjectsAttestorsCreate_578959;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; attestorId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsCreate
  ## Creates an attestor, and returns a copy of the new
  ## attestor. Returns NOT_FOUND if the project does not exist,
  ## INVALID_ARGUMENT if the request is malformed, ALREADY_EXISTS if the
  ## attestor already exists.
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
  ##         : Required. The parent of this attestor.
  ##   attestorId: string
  ##             : Required. The attestors ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  var body_578980 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578980 = body
  add(query_578979, "callback", newJString(callback))
  add(path_578978, "parent", newJString(parent))
  add(query_578979, "attestorId", newJString(attestorId))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, body_578980)

var binaryauthorizationProjectsAttestorsCreate* = Call_BinaryauthorizationProjectsAttestorsCreate_578959(
    name: "binaryauthorizationProjectsAttestorsCreate", meth: HttpMethod.HttpPost,
    host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{parent}/attestors",
    validator: validate_BinaryauthorizationProjectsAttestorsCreate_578960,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsCreate_578961,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsList_578938 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsList_578940(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/attestors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsList_578939(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists attestors.
  ## Returns INVALID_ARGUMENT if the project does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project associated with the
  ## attestors, in the format `projects/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578941 = path.getOrDefault("parent")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "parent", valid_578941
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
  ##           : Requested page size. The server may return fewer results than requested. If
  ## unspecified, the server will pick an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of ListAttestorsResponse.next_page_token returned
  ## from the previous call to the `ListAttestors` method.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("pageSize")
  valid_578946 = validateParameter(valid_578946, JInt, required = false, default = nil)
  if valid_578946 != nil:
    section.add "pageSize", valid_578946
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
  var valid_578950 = query.getOrDefault("pageToken")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "pageToken", valid_578950
  var valid_578951 = query.getOrDefault("callback")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "callback", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  var valid_578953 = query.getOrDefault("access_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "access_token", valid_578953
  var valid_578954 = query.getOrDefault("upload_protocol")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "upload_protocol", valid_578954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578955: Call_BinaryauthorizationProjectsAttestorsList_578938;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists attestors.
  ## Returns INVALID_ARGUMENT if the project does not exist.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_BinaryauthorizationProjectsAttestorsList_578938;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsList
  ## Lists attestors.
  ## Returns INVALID_ARGUMENT if the project does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The server may return fewer results than requested. If
  ## unspecified, the server will pick an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of ListAttestorsResponse.next_page_token returned
  ## from the previous call to the `ListAttestors` method.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the project associated with the
  ## attestors, in the format `projects/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "$.xgafv", newJString(Xgafv))
  add(query_578958, "pageSize", newJInt(pageSize))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "uploadType", newJString(uploadType))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(query_578958, "pageToken", newJString(pageToken))
  add(query_578958, "callback", newJString(callback))
  add(path_578957, "parent", newJString(parent))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, nil)

var binaryauthorizationProjectsAttestorsList* = Call_BinaryauthorizationProjectsAttestorsList_578938(
    name: "binaryauthorizationProjectsAttestorsList", meth: HttpMethod.HttpGet,
    host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{parent}/attestors",
    validator: validate_BinaryauthorizationProjectsAttestorsList_578939,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsList_578940,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_578981 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsGetIamPolicy_578983(
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
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsGetIamPolicy_578982(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_578984 = path.getOrDefault("resource")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "resource", valid_578984
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
  var valid_578989 = query.getOrDefault("options.requestedPolicyVersion")
  valid_578989 = validateParameter(valid_578989, JInt, required = false, default = nil)
  if valid_578989 != nil:
    section.add "options.requestedPolicyVersion", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("uploadType")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "uploadType", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("callback")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "callback", valid_578993
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
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_578981;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsGetIamPolicy
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
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "$.xgafv", newJString(Xgafv))
  add(query_579000, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "uploadType", newJString(uploadType))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(path_578999, "resource", newJString(resource))
  add(query_579000, "callback", newJString(callback))
  add(query_579000, "fields", newJString(fields))
  add(query_579000, "access_token", newJString(accessToken))
  add(query_579000, "upload_protocol", newJString(uploadProtocol))
  result = call_578998.call(path_578999, query_579000, nil, nil, nil)

var binaryauthorizationProjectsAttestorsGetIamPolicy* = Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_578981(
    name: "binaryauthorizationProjectsAttestorsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_BinaryauthorizationProjectsAttestorsGetIamPolicy_578982,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsGetIamPolicy_578983,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_579001 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsSetIamPolicy_579003(
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
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsSetIamPolicy_579002(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_579004 = path.getOrDefault("resource")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "resource", valid_579004
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
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(true))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("$.xgafv")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("1"))
  if valid_579008 != nil:
    section.add "$.xgafv", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("callback")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "callback", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  var valid_579014 = query.getOrDefault("access_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "access_token", valid_579014
  var valid_579015 = query.getOrDefault("upload_protocol")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "upload_protocol", valid_579015
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

proc call*(call_579017: Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_579001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579017.validator(path, query, header, formData, body)
  let scheme = call_579017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579017.url(scheme.get, call_579017.host, call_579017.base,
                         call_579017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579017, url, valid)

proc call*(call_579018: Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_579001;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsSetIamPolicy
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
  var path_579019 = newJObject()
  var query_579020 = newJObject()
  var body_579021 = newJObject()
  add(query_579020, "key", newJString(key))
  add(query_579020, "prettyPrint", newJBool(prettyPrint))
  add(query_579020, "oauth_token", newJString(oauthToken))
  add(query_579020, "$.xgafv", newJString(Xgafv))
  add(query_579020, "alt", newJString(alt))
  add(query_579020, "uploadType", newJString(uploadType))
  add(query_579020, "quotaUser", newJString(quotaUser))
  add(path_579019, "resource", newJString(resource))
  if body != nil:
    body_579021 = body
  add(query_579020, "callback", newJString(callback))
  add(query_579020, "fields", newJString(fields))
  add(query_579020, "access_token", newJString(accessToken))
  add(query_579020, "upload_protocol", newJString(uploadProtocol))
  result = call_579018.call(path_579019, query_579020, nil, nil, body_579021)

var binaryauthorizationProjectsAttestorsSetIamPolicy* = Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_579001(
    name: "binaryauthorizationProjectsAttestorsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_BinaryauthorizationProjectsAttestorsSetIamPolicy_579002,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsSetIamPolicy_579003,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_579022 = ref object of OpenApiRestCall_578339
proc url_BinaryauthorizationProjectsAttestorsTestIamPermissions_579024(
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

proc validate_BinaryauthorizationProjectsAttestorsTestIamPermissions_579023(
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
  var valid_579025 = path.getOrDefault("resource")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "resource", valid_579025
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
  var valid_579026 = query.getOrDefault("key")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "key", valid_579026
  var valid_579027 = query.getOrDefault("prettyPrint")
  valid_579027 = validateParameter(valid_579027, JBool, required = false,
                                 default = newJBool(true))
  if valid_579027 != nil:
    section.add "prettyPrint", valid_579027
  var valid_579028 = query.getOrDefault("oauth_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "oauth_token", valid_579028
  var valid_579029 = query.getOrDefault("$.xgafv")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("1"))
  if valid_579029 != nil:
    section.add "$.xgafv", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("uploadType")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "uploadType", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("callback")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "callback", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("access_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "access_token", valid_579035
  var valid_579036 = query.getOrDefault("upload_protocol")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "upload_protocol", valid_579036
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

proc call*(call_579038: Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_579022;
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
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_579022;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## binaryauthorizationProjectsAttestorsTestIamPermissions
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
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  var body_579042 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "$.xgafv", newJString(Xgafv))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "uploadType", newJString(uploadType))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "resource", newJString(resource))
  if body != nil:
    body_579042 = body
  add(query_579041, "callback", newJString(callback))
  add(query_579041, "fields", newJString(fields))
  add(query_579041, "access_token", newJString(accessToken))
  add(query_579041, "upload_protocol", newJString(uploadProtocol))
  result = call_579039.call(path_579040, query_579041, nil, nil, body_579042)

var binaryauthorizationProjectsAttestorsTestIamPermissions* = Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_579022(
    name: "binaryauthorizationProjectsAttestorsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_BinaryauthorizationProjectsAttestorsTestIamPermissions_579023,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsTestIamPermissions_579024,
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
