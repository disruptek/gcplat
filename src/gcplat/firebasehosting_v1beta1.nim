
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Firebase Hosting
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Firebase Hosting REST API enables programmatic and customizable deployments to your Firebase-hosted sites. Use this REST API to deploy new or updated hosting configurations and content files.
## 
## https://firebase.google.com/docs/hosting/
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
  gcpServiceName = "firebasehosting"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebasehostingSitesDomainsUpdate_593965 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesDomainsUpdate_593967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesDomainsUpdate_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified domain mapping, creating the mapping as if it does
  ## not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the domain association to update or create, if an
  ## association doesn't already exist.
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

proc call*(call_593981: Call_FirebasehostingSitesDomainsUpdate_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping, creating the mapping as if it does
  ## not exist.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_FirebasehostingSitesDomainsUpdate_593965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesDomainsUpdate
  ## Updates the specified domain mapping, creating the mapping as if it does
  ## not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the domain association to update or create, if an
  ## association doesn't already exist.
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

var firebasehostingSitesDomainsUpdate* = Call_FirebasehostingSitesDomainsUpdate_593965(
    name: "firebasehostingSitesDomainsUpdate", meth: HttpMethod.HttpPut,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesDomainsUpdate_593966, base: "/",
    url: url_FirebasehostingSitesDomainsUpdate_593967, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsGet_593677 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesDomainsGet_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesDomainsGet_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a domain mapping on the specified site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the domain configuration to get.
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

proc call*(call_593852: Call_FirebasehostingSitesDomainsGet_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a domain mapping on the specified site.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_FirebasehostingSitesDomainsGet_593677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesDomainsGet
  ## Gets a domain mapping on the specified site.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the domain configuration to get.
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

var firebasehostingSitesDomainsGet* = Call_FirebasehostingSitesDomainsGet_593677(
    name: "firebasehostingSitesDomainsGet", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesDomainsGet_593678, base: "/",
    url: url_FirebasehostingSitesDomainsGet_593679, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsPatch_594005 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesVersionsPatch_594007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesVersionsPatch_594006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified metadata for a version. Note that this method will
  ## fail with `FAILED_PRECONDITION` in the event of an invalid state
  ## transition. The only valid transition for a version is currently from a
  ## `CREATED` status to a `FINALIZED` status.
  ## Use [`DeleteVersion`](../sites.versions/delete) to set the status of a
  ## version to `DELETED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique identifier for a version, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## This name is provided in the response body when you call the
  ## [`CreateVersion`](../sites.versions/create) endpoint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594008 = path.getOrDefault("name")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "name", valid_594008
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
  ##             : A set of field names from your [version](../sites.versions) that you want
  ## to update.
  ## <br>A field will be overwritten if, and only if, it's in the mask.
  ## <br>If a mask is not provided then a default mask of only
  ## [`status`](../sites.versions#Version.FIELDS.status) will be used.
  section = newJObject()
  var valid_594009 = query.getOrDefault("upload_protocol")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "upload_protocol", valid_594009
  var valid_594010 = query.getOrDefault("fields")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "fields", valid_594010
  var valid_594011 = query.getOrDefault("quotaUser")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "quotaUser", valid_594011
  var valid_594012 = query.getOrDefault("alt")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = newJString("json"))
  if valid_594012 != nil:
    section.add "alt", valid_594012
  var valid_594013 = query.getOrDefault("oauth_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "oauth_token", valid_594013
  var valid_594014 = query.getOrDefault("callback")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "callback", valid_594014
  var valid_594015 = query.getOrDefault("access_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "access_token", valid_594015
  var valid_594016 = query.getOrDefault("uploadType")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "uploadType", valid_594016
  var valid_594017 = query.getOrDefault("key")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "key", valid_594017
  var valid_594018 = query.getOrDefault("$.xgafv")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("1"))
  if valid_594018 != nil:
    section.add "$.xgafv", valid_594018
  var valid_594019 = query.getOrDefault("prettyPrint")
  valid_594019 = validateParameter(valid_594019, JBool, required = false,
                                 default = newJBool(true))
  if valid_594019 != nil:
    section.add "prettyPrint", valid_594019
  var valid_594020 = query.getOrDefault("updateMask")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "updateMask", valid_594020
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

proc call*(call_594022: Call_FirebasehostingSitesVersionsPatch_594005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified metadata for a version. Note that this method will
  ## fail with `FAILED_PRECONDITION` in the event of an invalid state
  ## transition. The only valid transition for a version is currently from a
  ## `CREATED` status to a `FINALIZED` status.
  ## Use [`DeleteVersion`](../sites.versions/delete) to set the status of a
  ## version to `DELETED`.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_FirebasehostingSitesVersionsPatch_594005;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## firebasehostingSitesVersionsPatch
  ## Updates the specified metadata for a version. Note that this method will
  ## fail with `FAILED_PRECONDITION` in the event of an invalid state
  ## transition. The only valid transition for a version is currently from a
  ## `CREATED` status to a `FINALIZED` status.
  ## Use [`DeleteVersion`](../sites.versions/delete) to set the status of a
  ## version to `DELETED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique identifier for a version, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## This name is provided in the response body when you call the
  ## [`CreateVersion`](../sites.versions/create) endpoint.
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
  ##             : A set of field names from your [version](../sites.versions) that you want
  ## to update.
  ## <br>A field will be overwritten if, and only if, it's in the mask.
  ## <br>If a mask is not provided then a default mask of only
  ## [`status`](../sites.versions#Version.FIELDS.status) will be used.
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
  add(query_594025, "updateMask", newJString(updateMask))
  result = call_594023.call(path_594024, query_594025, nil, nil, body_594026)

var firebasehostingSitesVersionsPatch* = Call_FirebasehostingSitesVersionsPatch_594005(
    name: "firebasehostingSitesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesVersionsPatch_594006, base: "/",
    url: url_FirebasehostingSitesVersionsPatch_594007, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsDelete_593986 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesDomainsDelete_593988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesDomainsDelete_593987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the existing domain mapping on the specified site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the domain association to delete.
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_FirebasehostingSitesDomainsDelete_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the existing domain mapping on the specified site.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_FirebasehostingSitesDomainsDelete_593986;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesDomainsDelete
  ## Deletes the existing domain mapping on the specified site.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the domain association to delete.
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(path_594003, "name", newJString(name))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var firebasehostingSitesDomainsDelete* = Call_FirebasehostingSitesDomainsDelete_593986(
    name: "firebasehostingSitesDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesDomainsDelete_593987, base: "/",
    url: url_FirebasehostingSitesDomainsDelete_593988, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsCreate_594048 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesDomainsCreate_594050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesDomainsCreate_594049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a domain mapping on the specified site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent to create the domain association for, in the format:
  ## <code>sites/<var>site-name</var></code>
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
  var valid_594054 = query.getOrDefault("quotaUser")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "quotaUser", valid_594054
  var valid_594055 = query.getOrDefault("alt")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("json"))
  if valid_594055 != nil:
    section.add "alt", valid_594055
  var valid_594056 = query.getOrDefault("oauth_token")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "oauth_token", valid_594056
  var valid_594057 = query.getOrDefault("callback")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "callback", valid_594057
  var valid_594058 = query.getOrDefault("access_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "access_token", valid_594058
  var valid_594059 = query.getOrDefault("uploadType")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "uploadType", valid_594059
  var valid_594060 = query.getOrDefault("key")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "key", valid_594060
  var valid_594061 = query.getOrDefault("$.xgafv")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("1"))
  if valid_594061 != nil:
    section.add "$.xgafv", valid_594061
  var valid_594062 = query.getOrDefault("prettyPrint")
  valid_594062 = validateParameter(valid_594062, JBool, required = false,
                                 default = newJBool(true))
  if valid_594062 != nil:
    section.add "prettyPrint", valid_594062
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

proc call*(call_594064: Call_FirebasehostingSitesDomainsCreate_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a domain mapping on the specified site.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_FirebasehostingSitesDomainsCreate_594048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesDomainsCreate
  ## Creates a domain mapping on the specified site.
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
  ##         : Required. The parent to create the domain association for, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(query_594067, "upload_protocol", newJString(uploadProtocol))
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "callback", newJString(callback))
  add(query_594067, "access_token", newJString(accessToken))
  add(query_594067, "uploadType", newJString(uploadType))
  add(path_594066, "parent", newJString(parent))
  add(query_594067, "key", newJString(key))
  add(query_594067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594068 = body
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var firebasehostingSitesDomainsCreate* = Call_FirebasehostingSitesDomainsCreate_594048(
    name: "firebasehostingSitesDomainsCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/domains",
    validator: validate_FirebasehostingSitesDomainsCreate_594049, base: "/",
    url: url_FirebasehostingSitesDomainsCreate_594050, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsList_594027 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesDomainsList_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesDomainsList_594028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the domains for the specified site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent for which to list domains, in the format:
  ## <code>sites/<var>site-name</var></code>
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
  ##            : The next_page_token from a previous request, if provided.
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
  ##           : The page size to return. Defaults to 50.
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

proc call*(call_594044: Call_FirebasehostingSitesDomainsList_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domains for the specified site.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_FirebasehostingSitesDomainsList_594027;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesDomainsList
  ## Lists the domains for the specified site.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided.
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
  ##         : Required. The parent for which to list domains, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 50.
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

var firebasehostingSitesDomainsList* = Call_FirebasehostingSitesDomainsList_594027(
    name: "firebasehostingSitesDomainsList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/domains",
    validator: validate_FirebasehostingSitesDomainsList_594028, base: "/",
    url: url_FirebasehostingSitesDomainsList_594029, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsFilesList_594069 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesVersionsFilesList_594071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesVersionsFilesList_594070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the remaining files to be uploaded for the specified version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent to list files for, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594072 = path.getOrDefault("parent")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "parent", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token from a previous request, if provided. This will be the
  ## encoded version of a firebase.hosting.proto.metadata.ListFilesPageToken.
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
  ##           : The page size to return. Defaults to 1000.
  ##   status: JString
  ##         : The type of files in the version that should be listed.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594073 = query.getOrDefault("upload_protocol")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "upload_protocol", valid_594073
  var valid_594074 = query.getOrDefault("fields")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "fields", valid_594074
  var valid_594075 = query.getOrDefault("pageToken")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "pageToken", valid_594075
  var valid_594076 = query.getOrDefault("quotaUser")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "quotaUser", valid_594076
  var valid_594077 = query.getOrDefault("alt")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("json"))
  if valid_594077 != nil:
    section.add "alt", valid_594077
  var valid_594078 = query.getOrDefault("oauth_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "oauth_token", valid_594078
  var valid_594079 = query.getOrDefault("callback")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "callback", valid_594079
  var valid_594080 = query.getOrDefault("access_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "access_token", valid_594080
  var valid_594081 = query.getOrDefault("uploadType")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "uploadType", valid_594081
  var valid_594082 = query.getOrDefault("key")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "key", valid_594082
  var valid_594083 = query.getOrDefault("$.xgafv")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = newJString("1"))
  if valid_594083 != nil:
    section.add "$.xgafv", valid_594083
  var valid_594084 = query.getOrDefault("pageSize")
  valid_594084 = validateParameter(valid_594084, JInt, required = false, default = nil)
  if valid_594084 != nil:
    section.add "pageSize", valid_594084
  var valid_594085 = query.getOrDefault("status")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("STATUS_UNSPECIFIED"))
  if valid_594085 != nil:
    section.add "status", valid_594085
  var valid_594086 = query.getOrDefault("prettyPrint")
  valid_594086 = validateParameter(valid_594086, JBool, required = false,
                                 default = newJBool(true))
  if valid_594086 != nil:
    section.add "prettyPrint", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_FirebasehostingSitesVersionsFilesList_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the remaining files to be uploaded for the specified version.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_FirebasehostingSitesVersionsFilesList_594069;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          status: string = "STATUS_UNSPECIFIED"; prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesVersionsFilesList
  ## Lists the remaining files to be uploaded for the specified version.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided. This will be the
  ## encoded version of a firebase.hosting.proto.metadata.ListFilesPageToken.
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
  ##         : Required. The parent to list files for, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 1000.
  ##   status: string
  ##         : The type of files in the version that should be listed.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(query_594090, "upload_protocol", newJString(uploadProtocol))
  add(query_594090, "fields", newJString(fields))
  add(query_594090, "pageToken", newJString(pageToken))
  add(query_594090, "quotaUser", newJString(quotaUser))
  add(query_594090, "alt", newJString(alt))
  add(query_594090, "oauth_token", newJString(oauthToken))
  add(query_594090, "callback", newJString(callback))
  add(query_594090, "access_token", newJString(accessToken))
  add(query_594090, "uploadType", newJString(uploadType))
  add(path_594089, "parent", newJString(parent))
  add(query_594090, "key", newJString(key))
  add(query_594090, "$.xgafv", newJString(Xgafv))
  add(query_594090, "pageSize", newJInt(pageSize))
  add(query_594090, "status", newJString(status))
  add(query_594090, "prettyPrint", newJBool(prettyPrint))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var firebasehostingSitesVersionsFilesList* = Call_FirebasehostingSitesVersionsFilesList_594069(
    name: "firebasehostingSitesVersionsFilesList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/files",
    validator: validate_FirebasehostingSitesVersionsFilesList_594070, base: "/",
    url: url_FirebasehostingSitesVersionsFilesList_594071, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesReleasesCreate_594112 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesReleasesCreate_594114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesReleasesCreate_594113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new release which makes the content of the specified version
  ## actively display on the site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The site that the release belongs to, in the format:
  ## <code>sites/<var>site-name</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594115 = path.getOrDefault("parent")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "parent", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   versionName: JString
  ##              : The unique identifier for a version, in the format:
  ## <code>/sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## The <var>site-name</var> in this version identifier must match the
  ## <var>site-name</var> in the `parent` parameter.
  ## <br>
  ## <br>This query parameter must be empty if the `type` field in the
  ## request body is `SITE_DISABLE`.
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
  var valid_594116 = query.getOrDefault("upload_protocol")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "upload_protocol", valid_594116
  var valid_594117 = query.getOrDefault("fields")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "fields", valid_594117
  var valid_594118 = query.getOrDefault("versionName")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "versionName", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("oauth_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "oauth_token", valid_594121
  var valid_594122 = query.getOrDefault("callback")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "callback", valid_594122
  var valid_594123 = query.getOrDefault("access_token")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "access_token", valid_594123
  var valid_594124 = query.getOrDefault("uploadType")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "uploadType", valid_594124
  var valid_594125 = query.getOrDefault("key")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "key", valid_594125
  var valid_594126 = query.getOrDefault("$.xgafv")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("1"))
  if valid_594126 != nil:
    section.add "$.xgafv", valid_594126
  var valid_594127 = query.getOrDefault("prettyPrint")
  valid_594127 = validateParameter(valid_594127, JBool, required = false,
                                 default = newJBool(true))
  if valid_594127 != nil:
    section.add "prettyPrint", valid_594127
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

proc call*(call_594129: Call_FirebasehostingSitesReleasesCreate_594112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new release which makes the content of the specified version
  ## actively display on the site.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_FirebasehostingSitesReleasesCreate_594112;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          versionName: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesReleasesCreate
  ## Creates a new release which makes the content of the specified version
  ## actively display on the site.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   versionName: string
  ##              : The unique identifier for a version, in the format:
  ## <code>/sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## The <var>site-name</var> in this version identifier must match the
  ## <var>site-name</var> in the `parent` parameter.
  ## <br>
  ## <br>This query parameter must be empty if the `type` field in the
  ## request body is `SITE_DISABLE`.
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
  ##         : The site that the release belongs to, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  var body_594133 = newJObject()
  add(query_594132, "upload_protocol", newJString(uploadProtocol))
  add(query_594132, "fields", newJString(fields))
  add(query_594132, "versionName", newJString(versionName))
  add(query_594132, "quotaUser", newJString(quotaUser))
  add(query_594132, "alt", newJString(alt))
  add(query_594132, "oauth_token", newJString(oauthToken))
  add(query_594132, "callback", newJString(callback))
  add(query_594132, "access_token", newJString(accessToken))
  add(query_594132, "uploadType", newJString(uploadType))
  add(path_594131, "parent", newJString(parent))
  add(query_594132, "key", newJString(key))
  add(query_594132, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594133 = body
  add(query_594132, "prettyPrint", newJBool(prettyPrint))
  result = call_594130.call(path_594131, query_594132, nil, nil, body_594133)

var firebasehostingSitesReleasesCreate* = Call_FirebasehostingSitesReleasesCreate_594112(
    name: "firebasehostingSitesReleasesCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/releases",
    validator: validate_FirebasehostingSitesReleasesCreate_594113, base: "/",
    url: url_FirebasehostingSitesReleasesCreate_594114, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesReleasesList_594091 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesReleasesList_594093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesReleasesList_594092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the releases that have been created on the specified site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent for which to list files, in the format:
  ## <code>sites/<var>site-name</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594094 = path.getOrDefault("parent")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "parent", valid_594094
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token from a previous request, if provided.
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
  ##           : The page size to return. Defaults to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594095 = query.getOrDefault("upload_protocol")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "upload_protocol", valid_594095
  var valid_594096 = query.getOrDefault("fields")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "fields", valid_594096
  var valid_594097 = query.getOrDefault("pageToken")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "pageToken", valid_594097
  var valid_594098 = query.getOrDefault("quotaUser")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "quotaUser", valid_594098
  var valid_594099 = query.getOrDefault("alt")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = newJString("json"))
  if valid_594099 != nil:
    section.add "alt", valid_594099
  var valid_594100 = query.getOrDefault("oauth_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "oauth_token", valid_594100
  var valid_594101 = query.getOrDefault("callback")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "callback", valid_594101
  var valid_594102 = query.getOrDefault("access_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "access_token", valid_594102
  var valid_594103 = query.getOrDefault("uploadType")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "uploadType", valid_594103
  var valid_594104 = query.getOrDefault("key")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "key", valid_594104
  var valid_594105 = query.getOrDefault("$.xgafv")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("1"))
  if valid_594105 != nil:
    section.add "$.xgafv", valid_594105
  var valid_594106 = query.getOrDefault("pageSize")
  valid_594106 = validateParameter(valid_594106, JInt, required = false, default = nil)
  if valid_594106 != nil:
    section.add "pageSize", valid_594106
  var valid_594107 = query.getOrDefault("prettyPrint")
  valid_594107 = validateParameter(valid_594107, JBool, required = false,
                                 default = newJBool(true))
  if valid_594107 != nil:
    section.add "prettyPrint", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_FirebasehostingSitesReleasesList_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the releases that have been created on the specified site.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_FirebasehostingSitesReleasesList_594091;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesReleasesList
  ## Lists the releases that have been created on the specified site.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided.
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
  ##         : Required. The parent for which to list files, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(query_594111, "upload_protocol", newJString(uploadProtocol))
  add(query_594111, "fields", newJString(fields))
  add(query_594111, "pageToken", newJString(pageToken))
  add(query_594111, "quotaUser", newJString(quotaUser))
  add(query_594111, "alt", newJString(alt))
  add(query_594111, "oauth_token", newJString(oauthToken))
  add(query_594111, "callback", newJString(callback))
  add(query_594111, "access_token", newJString(accessToken))
  add(query_594111, "uploadType", newJString(uploadType))
  add(path_594110, "parent", newJString(parent))
  add(query_594111, "key", newJString(key))
  add(query_594111, "$.xgafv", newJString(Xgafv))
  add(query_594111, "pageSize", newJInt(pageSize))
  add(query_594111, "prettyPrint", newJBool(prettyPrint))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var firebasehostingSitesReleasesList* = Call_FirebasehostingSitesReleasesList_594091(
    name: "firebasehostingSitesReleasesList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/releases",
    validator: validate_FirebasehostingSitesReleasesList_594092, base: "/",
    url: url_FirebasehostingSitesReleasesList_594093, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsCreate_594134 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesVersionsCreate_594136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesVersionsCreate_594135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version for a site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent to create the version for, in the format:
  ## <code>sites/<var>site-name</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594137 = path.getOrDefault("parent")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "parent", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : A unique id for the new version. This is only specified for legacy version
  ## creations.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   sizeBytes: JString
  ##            : The self-reported size of the version. This value is used for a pre-emptive
  ## quota check for legacy version uploads.
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
  var valid_594138 = query.getOrDefault("versionId")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "versionId", valid_594138
  var valid_594139 = query.getOrDefault("upload_protocol")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "upload_protocol", valid_594139
  var valid_594140 = query.getOrDefault("sizeBytes")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "sizeBytes", valid_594140
  var valid_594141 = query.getOrDefault("fields")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "fields", valid_594141
  var valid_594142 = query.getOrDefault("quotaUser")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "quotaUser", valid_594142
  var valid_594143 = query.getOrDefault("alt")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = newJString("json"))
  if valid_594143 != nil:
    section.add "alt", valid_594143
  var valid_594144 = query.getOrDefault("oauth_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "oauth_token", valid_594144
  var valid_594145 = query.getOrDefault("callback")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "callback", valid_594145
  var valid_594146 = query.getOrDefault("access_token")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "access_token", valid_594146
  var valid_594147 = query.getOrDefault("uploadType")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "uploadType", valid_594147
  var valid_594148 = query.getOrDefault("key")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "key", valid_594148
  var valid_594149 = query.getOrDefault("$.xgafv")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("1"))
  if valid_594149 != nil:
    section.add "$.xgafv", valid_594149
  var valid_594150 = query.getOrDefault("prettyPrint")
  valid_594150 = validateParameter(valid_594150, JBool, required = false,
                                 default = newJBool(true))
  if valid_594150 != nil:
    section.add "prettyPrint", valid_594150
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

proc call*(call_594152: Call_FirebasehostingSitesVersionsCreate_594134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new version for a site.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_FirebasehostingSitesVersionsCreate_594134;
          parent: string; versionId: string = ""; uploadProtocol: string = "";
          sizeBytes: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesVersionsCreate
  ## Creates a new version for a site.
  ##   versionId: string
  ##            : A unique id for the new version. This is only specified for legacy version
  ## creations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   sizeBytes: string
  ##            : The self-reported size of the version. This value is used for a pre-emptive
  ## quota check for legacy version uploads.
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
  ##         : Required. The parent to create the version for, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  var body_594156 = newJObject()
  add(query_594155, "versionId", newJString(versionId))
  add(query_594155, "upload_protocol", newJString(uploadProtocol))
  add(query_594155, "sizeBytes", newJString(sizeBytes))
  add(query_594155, "fields", newJString(fields))
  add(query_594155, "quotaUser", newJString(quotaUser))
  add(query_594155, "alt", newJString(alt))
  add(query_594155, "oauth_token", newJString(oauthToken))
  add(query_594155, "callback", newJString(callback))
  add(query_594155, "access_token", newJString(accessToken))
  add(query_594155, "uploadType", newJString(uploadType))
  add(path_594154, "parent", newJString(parent))
  add(query_594155, "key", newJString(key))
  add(query_594155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594156 = body
  add(query_594155, "prettyPrint", newJBool(prettyPrint))
  result = call_594153.call(path_594154, query_594155, nil, nil, body_594156)

var firebasehostingSitesVersionsCreate* = Call_FirebasehostingSitesVersionsCreate_594134(
    name: "firebasehostingSitesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_FirebasehostingSitesVersionsCreate_594135, base: "/",
    url: url_FirebasehostingSitesVersionsCreate_594136, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsPopulateFiles_594157 = ref object of OpenApiRestCall_593408
proc url_FirebasehostingSitesVersionsPopulateFiles_594159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":populateFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebasehostingSitesVersionsPopulateFiles_594158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds content files to a version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The version to add files to, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
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
  var valid_594170 = query.getOrDefault("$.xgafv")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("1"))
  if valid_594170 != nil:
    section.add "$.xgafv", valid_594170
  var valid_594171 = query.getOrDefault("prettyPrint")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(true))
  if valid_594171 != nil:
    section.add "prettyPrint", valid_594171
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

proc call*(call_594173: Call_FirebasehostingSitesVersionsPopulateFiles_594157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds content files to a version.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_FirebasehostingSitesVersionsPopulateFiles_594157;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebasehostingSitesVersionsPopulateFiles
  ## Adds content files to a version.
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
  ##         : Required. The version to add files to, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  var body_594177 = newJObject()
  add(query_594176, "upload_protocol", newJString(uploadProtocol))
  add(query_594176, "fields", newJString(fields))
  add(query_594176, "quotaUser", newJString(quotaUser))
  add(query_594176, "alt", newJString(alt))
  add(query_594176, "oauth_token", newJString(oauthToken))
  add(query_594176, "callback", newJString(callback))
  add(query_594176, "access_token", newJString(accessToken))
  add(query_594176, "uploadType", newJString(uploadType))
  add(path_594175, "parent", newJString(parent))
  add(query_594176, "key", newJString(key))
  add(query_594176, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594177 = body
  add(query_594176, "prettyPrint", newJBool(prettyPrint))
  result = call_594174.call(path_594175, query_594176, nil, nil, body_594177)

var firebasehostingSitesVersionsPopulateFiles* = Call_FirebasehostingSitesVersionsPopulateFiles_594157(
    name: "firebasehostingSitesVersionsPopulateFiles", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com",
    route: "/v1beta1/{parent}:populateFiles",
    validator: validate_FirebasehostingSitesVersionsPopulateFiles_594158,
    base: "/", url: url_FirebasehostingSitesVersionsPopulateFiles_594159,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
