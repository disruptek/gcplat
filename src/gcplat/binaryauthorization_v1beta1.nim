
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "binaryauthorization"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BinaryauthorizationProjectsAttestorsUpdate_597965 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsUpdate_597967(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsUpdate_597966(path: JsonNode;
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
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
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

proc call*(call_597981: Call_BinaryauthorizationProjectsAttestorsUpdate_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  let valid = call_597981.validator(path, query, header, formData, body)
  let scheme = call_597981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597981.url(scheme.get, call_597981.host, call_597981.base,
                         call_597981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597981, url, valid)

proc call*(call_597982: Call_BinaryauthorizationProjectsAttestorsUpdate_597965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsUpdate
  ## Updates an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name, in the format:
  ## `projects/*/attestors/*`. This field may not be updated.
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
  var path_597983 = newJObject()
  var query_597984 = newJObject()
  var body_597985 = newJObject()
  add(query_597984, "upload_protocol", newJString(uploadProtocol))
  add(query_597984, "fields", newJString(fields))
  add(query_597984, "quotaUser", newJString(quotaUser))
  add(path_597983, "name", newJString(name))
  add(query_597984, "alt", newJString(alt))
  add(query_597984, "oauth_token", newJString(oauthToken))
  add(query_597984, "callback", newJString(callback))
  add(query_597984, "access_token", newJString(accessToken))
  add(query_597984, "uploadType", newJString(uploadType))
  add(query_597984, "key", newJString(key))
  add(query_597984, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597985 = body
  add(query_597984, "prettyPrint", newJBool(prettyPrint))
  result = call_597982.call(path_597983, query_597984, nil, nil, body_597985)

var binaryauthorizationProjectsAttestorsUpdate* = Call_BinaryauthorizationProjectsAttestorsUpdate_597965(
    name: "binaryauthorizationProjectsAttestorsUpdate", meth: HttpMethod.HttpPut,
    host: "binaryauthorization.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsUpdate_597966,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsUpdate_597967,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsGet_597677 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsGet_597679(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsGet_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_BinaryauthorizationProjectsAttestorsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_BinaryauthorizationProjectsAttestorsGet_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsGet
  ## Gets an attestor.
  ## Returns NOT_FOUND if the attestor does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the attestor to retrieve, in the format
  ## `projects/*/attestors/*`.
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var binaryauthorizationProjectsAttestorsGet* = Call_BinaryauthorizationProjectsAttestorsGet_597677(
    name: "binaryauthorizationProjectsAttestorsGet", meth: HttpMethod.HttpGet,
    host: "binaryauthorization.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsGet_597678, base: "/",
    url: url_BinaryauthorizationProjectsAttestorsGet_597679,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsDelete_597986 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsDelete_597988(protocol: Scheme;
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

proc validate_BinaryauthorizationProjectsAttestorsDelete_597987(path: JsonNode;
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
  var valid_597989 = path.getOrDefault("name")
  valid_597989 = validateParameter(valid_597989, JString, required = true,
                                 default = nil)
  if valid_597989 != nil:
    section.add "name", valid_597989
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
  var valid_597990 = query.getOrDefault("upload_protocol")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "upload_protocol", valid_597990
  var valid_597991 = query.getOrDefault("fields")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "fields", valid_597991
  var valid_597992 = query.getOrDefault("quotaUser")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "quotaUser", valid_597992
  var valid_597993 = query.getOrDefault("alt")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = newJString("json"))
  if valid_597993 != nil:
    section.add "alt", valid_597993
  var valid_597994 = query.getOrDefault("oauth_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "oauth_token", valid_597994
  var valid_597995 = query.getOrDefault("callback")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "callback", valid_597995
  var valid_597996 = query.getOrDefault("access_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "access_token", valid_597996
  var valid_597997 = query.getOrDefault("uploadType")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "uploadType", valid_597997
  var valid_597998 = query.getOrDefault("key")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "key", valid_597998
  var valid_597999 = query.getOrDefault("$.xgafv")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("1"))
  if valid_597999 != nil:
    section.add "$.xgafv", valid_597999
  var valid_598000 = query.getOrDefault("prettyPrint")
  valid_598000 = validateParameter(valid_598000, JBool, required = false,
                                 default = newJBool(true))
  if valid_598000 != nil:
    section.add "prettyPrint", valid_598000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598001: Call_BinaryauthorizationProjectsAttestorsDelete_597986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an attestor. Returns NOT_FOUND if the
  ## attestor does not exist.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_BinaryauthorizationProjectsAttestorsDelete_597986;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsDelete
  ## Deletes an attestor. Returns NOT_FOUND if the
  ## attestor does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the attestors to delete, in the format
  ## `projects/*/attestors/*`.
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
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  result = call_598002.call(path_598003, query_598004, nil, nil, nil)

var binaryauthorizationProjectsAttestorsDelete* = Call_BinaryauthorizationProjectsAttestorsDelete_597986(
    name: "binaryauthorizationProjectsAttestorsDelete",
    meth: HttpMethod.HttpDelete, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BinaryauthorizationProjectsAttestorsDelete_597987,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsDelete_597988,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsCreate_598026 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsCreate_598028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BinaryauthorizationProjectsAttestorsCreate_598027(path: JsonNode;
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
  var valid_598029 = path.getOrDefault("parent")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "parent", valid_598029
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
  ##   attestorId: JString
  ##             : Required. The attestors ID.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598030 = query.getOrDefault("upload_protocol")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "upload_protocol", valid_598030
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("uploadType")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "uploadType", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("attestorId")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "attestorId", valid_598039
  var valid_598040 = query.getOrDefault("$.xgafv")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = newJString("1"))
  if valid_598040 != nil:
    section.add "$.xgafv", valid_598040
  var valid_598041 = query.getOrDefault("prettyPrint")
  valid_598041 = validateParameter(valid_598041, JBool, required = false,
                                 default = newJBool(true))
  if valid_598041 != nil:
    section.add "prettyPrint", valid_598041
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

proc call*(call_598043: Call_BinaryauthorizationProjectsAttestorsCreate_598026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an attestor, and returns a copy of the new
  ## attestor. Returns NOT_FOUND if the project does not exist,
  ## INVALID_ARGUMENT if the request is malformed, ALREADY_EXISTS if the
  ## attestor already exists.
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_BinaryauthorizationProjectsAttestorsCreate_598026;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; attestorId: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsCreate
  ## Creates an attestor, and returns a copy of the new
  ## attestor. Returns NOT_FOUND if the project does not exist,
  ## INVALID_ARGUMENT if the request is malformed, ALREADY_EXISTS if the
  ## attestor already exists.
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
  ##         : Required. The parent of this attestor.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   attestorId: string
  ##             : Required. The attestors ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  var body_598047 = newJObject()
  add(query_598046, "upload_protocol", newJString(uploadProtocol))
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "callback", newJString(callback))
  add(query_598046, "access_token", newJString(accessToken))
  add(query_598046, "uploadType", newJString(uploadType))
  add(path_598045, "parent", newJString(parent))
  add(query_598046, "key", newJString(key))
  add(query_598046, "attestorId", newJString(attestorId))
  add(query_598046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598047 = body
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, body_598047)

var binaryauthorizationProjectsAttestorsCreate* = Call_BinaryauthorizationProjectsAttestorsCreate_598026(
    name: "binaryauthorizationProjectsAttestorsCreate", meth: HttpMethod.HttpPost,
    host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{parent}/attestors",
    validator: validate_BinaryauthorizationProjectsAttestorsCreate_598027,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsCreate_598028,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsList_598005 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsList_598007(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BinaryauthorizationProjectsAttestorsList_598006(path: JsonNode;
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
  var valid_598008 = path.getOrDefault("parent")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "parent", valid_598008
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of ListAttestorsResponse.next_page_token returned
  ## from the previous call to the `ListAttestors` method.
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
  ##           : Requested page size. The server may return fewer results than requested. If
  ## unspecified, the server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598009 = query.getOrDefault("upload_protocol")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "upload_protocol", valid_598009
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("pageToken")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "pageToken", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("callback")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "callback", valid_598015
  var valid_598016 = query.getOrDefault("access_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "access_token", valid_598016
  var valid_598017 = query.getOrDefault("uploadType")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "uploadType", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("pageSize")
  valid_598020 = validateParameter(valid_598020, JInt, required = false, default = nil)
  if valid_598020 != nil:
    section.add "pageSize", valid_598020
  var valid_598021 = query.getOrDefault("prettyPrint")
  valid_598021 = validateParameter(valid_598021, JBool, required = false,
                                 default = newJBool(true))
  if valid_598021 != nil:
    section.add "prettyPrint", valid_598021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598022: Call_BinaryauthorizationProjectsAttestorsList_598005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists attestors.
  ## Returns INVALID_ARGUMENT if the project does not exist.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_BinaryauthorizationProjectsAttestorsList_598005;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsList
  ## Lists attestors.
  ## Returns INVALID_ARGUMENT if the project does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of ListAttestorsResponse.next_page_token returned
  ## from the previous call to the `ListAttestors` method.
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
  ##         : Required. The resource name of the project associated with the
  ## attestors, in the format `projects/*`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The server may return fewer results than requested. If
  ## unspecified, the server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  add(query_598025, "upload_protocol", newJString(uploadProtocol))
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "pageToken", newJString(pageToken))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(query_598025, "callback", newJString(callback))
  add(query_598025, "access_token", newJString(accessToken))
  add(query_598025, "uploadType", newJString(uploadType))
  add(path_598024, "parent", newJString(parent))
  add(query_598025, "key", newJString(key))
  add(query_598025, "$.xgafv", newJString(Xgafv))
  add(query_598025, "pageSize", newJInt(pageSize))
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, nil)

var binaryauthorizationProjectsAttestorsList* = Call_BinaryauthorizationProjectsAttestorsList_598005(
    name: "binaryauthorizationProjectsAttestorsList", meth: HttpMethod.HttpGet,
    host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{parent}/attestors",
    validator: validate_BinaryauthorizationProjectsAttestorsList_598006,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsList_598007,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_598048 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsGetIamPolicy_598050(
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
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsGetIamPolicy_598049(
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
  var valid_598051 = path.getOrDefault("resource")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "resource", valid_598051
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
  var valid_598052 = query.getOrDefault("upload_protocol")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "upload_protocol", valid_598052
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("quotaUser")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "quotaUser", valid_598054
  var valid_598055 = query.getOrDefault("alt")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = newJString("json"))
  if valid_598055 != nil:
    section.add "alt", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("callback")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "callback", valid_598057
  var valid_598058 = query.getOrDefault("access_token")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "access_token", valid_598058
  var valid_598059 = query.getOrDefault("uploadType")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "uploadType", valid_598059
  var valid_598060 = query.getOrDefault("options.requestedPolicyVersion")
  valid_598060 = validateParameter(valid_598060, JInt, required = false, default = nil)
  if valid_598060 != nil:
    section.add "options.requestedPolicyVersion", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("$.xgafv")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("1"))
  if valid_598062 != nil:
    section.add "$.xgafv", valid_598062
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598064: Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_598048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_598064.validator(path, query, header, formData, body)
  let scheme = call_598064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598064.url(scheme.get, call_598064.host, call_598064.base,
                         call_598064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598064, url, valid)

proc call*(call_598065: Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_598048;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsGetIamPolicy
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
  var path_598066 = newJObject()
  var query_598067 = newJObject()
  add(query_598067, "upload_protocol", newJString(uploadProtocol))
  add(query_598067, "fields", newJString(fields))
  add(query_598067, "quotaUser", newJString(quotaUser))
  add(query_598067, "alt", newJString(alt))
  add(query_598067, "oauth_token", newJString(oauthToken))
  add(query_598067, "callback", newJString(callback))
  add(query_598067, "access_token", newJString(accessToken))
  add(query_598067, "uploadType", newJString(uploadType))
  add(query_598067, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_598067, "key", newJString(key))
  add(query_598067, "$.xgafv", newJString(Xgafv))
  add(path_598066, "resource", newJString(resource))
  add(query_598067, "prettyPrint", newJBool(prettyPrint))
  result = call_598065.call(path_598066, query_598067, nil, nil, nil)

var binaryauthorizationProjectsAttestorsGetIamPolicy* = Call_BinaryauthorizationProjectsAttestorsGetIamPolicy_598048(
    name: "binaryauthorizationProjectsAttestorsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_BinaryauthorizationProjectsAttestorsGetIamPolicy_598049,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsGetIamPolicy_598050,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_598068 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsSetIamPolicy_598070(
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
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BinaryauthorizationProjectsAttestorsSetIamPolicy_598069(
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
  var valid_598071 = path.getOrDefault("resource")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "resource", valid_598071
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
  var valid_598072 = query.getOrDefault("upload_protocol")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "upload_protocol", valid_598072
  var valid_598073 = query.getOrDefault("fields")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fields", valid_598073
  var valid_598074 = query.getOrDefault("quotaUser")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "quotaUser", valid_598074
  var valid_598075 = query.getOrDefault("alt")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("json"))
  if valid_598075 != nil:
    section.add "alt", valid_598075
  var valid_598076 = query.getOrDefault("oauth_token")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "oauth_token", valid_598076
  var valid_598077 = query.getOrDefault("callback")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "callback", valid_598077
  var valid_598078 = query.getOrDefault("access_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "access_token", valid_598078
  var valid_598079 = query.getOrDefault("uploadType")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "uploadType", valid_598079
  var valid_598080 = query.getOrDefault("key")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "key", valid_598080
  var valid_598081 = query.getOrDefault("$.xgafv")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = newJString("1"))
  if valid_598081 != nil:
    section.add "$.xgafv", valid_598081
  var valid_598082 = query.getOrDefault("prettyPrint")
  valid_598082 = validateParameter(valid_598082, JBool, required = false,
                                 default = newJBool(true))
  if valid_598082 != nil:
    section.add "prettyPrint", valid_598082
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

proc call*(call_598084: Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_598068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_598084.validator(path, query, header, formData, body)
  let scheme = call_598084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598084.url(scheme.get, call_598084.host, call_598084.base,
                         call_598084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598084, url, valid)

proc call*(call_598085: Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_598068;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsSetIamPolicy
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
  var path_598086 = newJObject()
  var query_598087 = newJObject()
  var body_598088 = newJObject()
  add(query_598087, "upload_protocol", newJString(uploadProtocol))
  add(query_598087, "fields", newJString(fields))
  add(query_598087, "quotaUser", newJString(quotaUser))
  add(query_598087, "alt", newJString(alt))
  add(query_598087, "oauth_token", newJString(oauthToken))
  add(query_598087, "callback", newJString(callback))
  add(query_598087, "access_token", newJString(accessToken))
  add(query_598087, "uploadType", newJString(uploadType))
  add(query_598087, "key", newJString(key))
  add(query_598087, "$.xgafv", newJString(Xgafv))
  add(path_598086, "resource", newJString(resource))
  if body != nil:
    body_598088 = body
  add(query_598087, "prettyPrint", newJBool(prettyPrint))
  result = call_598085.call(path_598086, query_598087, nil, nil, body_598088)

var binaryauthorizationProjectsAttestorsSetIamPolicy* = Call_BinaryauthorizationProjectsAttestorsSetIamPolicy_598068(
    name: "binaryauthorizationProjectsAttestorsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_BinaryauthorizationProjectsAttestorsSetIamPolicy_598069,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsSetIamPolicy_598070,
    schemes: {Scheme.Https})
type
  Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_598089 = ref object of OpenApiRestCall_597408
proc url_BinaryauthorizationProjectsAttestorsTestIamPermissions_598091(
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

proc validate_BinaryauthorizationProjectsAttestorsTestIamPermissions_598090(
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
  var valid_598092 = path.getOrDefault("resource")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "resource", valid_598092
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
  var valid_598093 = query.getOrDefault("upload_protocol")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "upload_protocol", valid_598093
  var valid_598094 = query.getOrDefault("fields")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "fields", valid_598094
  var valid_598095 = query.getOrDefault("quotaUser")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "quotaUser", valid_598095
  var valid_598096 = query.getOrDefault("alt")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = newJString("json"))
  if valid_598096 != nil:
    section.add "alt", valid_598096
  var valid_598097 = query.getOrDefault("oauth_token")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "oauth_token", valid_598097
  var valid_598098 = query.getOrDefault("callback")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "callback", valid_598098
  var valid_598099 = query.getOrDefault("access_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "access_token", valid_598099
  var valid_598100 = query.getOrDefault("uploadType")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "uploadType", valid_598100
  var valid_598101 = query.getOrDefault("key")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "key", valid_598101
  var valid_598102 = query.getOrDefault("$.xgafv")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("1"))
  if valid_598102 != nil:
    section.add "$.xgafv", valid_598102
  var valid_598103 = query.getOrDefault("prettyPrint")
  valid_598103 = validateParameter(valid_598103, JBool, required = false,
                                 default = newJBool(true))
  if valid_598103 != nil:
    section.add "prettyPrint", valid_598103
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

proc call*(call_598105: Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_598089;
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
  let valid = call_598105.validator(path, query, header, formData, body)
  let scheme = call_598105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598105.url(scheme.get, call_598105.host, call_598105.base,
                         call_598105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598105, url, valid)

proc call*(call_598106: Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_598089;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## binaryauthorizationProjectsAttestorsTestIamPermissions
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
  var path_598107 = newJObject()
  var query_598108 = newJObject()
  var body_598109 = newJObject()
  add(query_598108, "upload_protocol", newJString(uploadProtocol))
  add(query_598108, "fields", newJString(fields))
  add(query_598108, "quotaUser", newJString(quotaUser))
  add(query_598108, "alt", newJString(alt))
  add(query_598108, "oauth_token", newJString(oauthToken))
  add(query_598108, "callback", newJString(callback))
  add(query_598108, "access_token", newJString(accessToken))
  add(query_598108, "uploadType", newJString(uploadType))
  add(query_598108, "key", newJString(key))
  add(query_598108, "$.xgafv", newJString(Xgafv))
  add(path_598107, "resource", newJString(resource))
  if body != nil:
    body_598109 = body
  add(query_598108, "prettyPrint", newJBool(prettyPrint))
  result = call_598106.call(path_598107, query_598108, nil, nil, body_598109)

var binaryauthorizationProjectsAttestorsTestIamPermissions* = Call_BinaryauthorizationProjectsAttestorsTestIamPermissions_598089(
    name: "binaryauthorizationProjectsAttestorsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "binaryauthorization.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_BinaryauthorizationProjectsAttestorsTestIamPermissions_598090,
    base: "/", url: url_BinaryauthorizationProjectsAttestorsTestIamPermissions_598091,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
