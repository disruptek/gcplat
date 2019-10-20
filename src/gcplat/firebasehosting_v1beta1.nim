
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "firebasehosting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebasehostingSitesDomainsUpdate_578898 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesDomainsUpdate_578900(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesDomainsUpdate_578899(path: JsonNode;
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

proc call*(call_578914: Call_FirebasehostingSitesDomainsUpdate_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping, creating the mapping as if it does
  ## not exist.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_FirebasehostingSitesDomainsUpdate_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesDomainsUpdate
  ## Updates the specified domain mapping, creating the mapping as if it does
  ## not exist.
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
  ##       : Required. The name of the domain association to update or create, if an
  ## association doesn't already exist.
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

var firebasehostingSitesDomainsUpdate* = Call_FirebasehostingSitesDomainsUpdate_578898(
    name: "firebasehostingSitesDomainsUpdate", meth: HttpMethod.HttpPut,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesDomainsUpdate_578899, base: "/",
    url: url_FirebasehostingSitesDomainsUpdate_578900, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsGet_578610 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesDomainsGet_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesDomainsGet_578611(path: JsonNode;
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

proc call*(call_578785: Call_FirebasehostingSitesDomainsGet_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a domain mapping on the specified site.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_FirebasehostingSitesDomainsGet_578610; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesDomainsGet
  ## Gets a domain mapping on the specified site.
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
  ##       : Required. The name of the domain configuration to get.
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

var firebasehostingSitesDomainsGet* = Call_FirebasehostingSitesDomainsGet_578610(
    name: "firebasehostingSitesDomainsGet", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesDomainsGet_578611, base: "/",
    url: url_FirebasehostingSitesDomainsGet_578612, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsPatch_578938 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesVersionsPatch_578940(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesVersionsPatch_578939(path: JsonNode;
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
  var valid_578941 = path.getOrDefault("name")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "name", valid_578941
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
  ##   updateMask: JString
  ##             : A set of field names from your [version](../sites.versions) that you want
  ## to update.
  ## <br>A field will be overwritten if, and only if, it's in the mask.
  ## <br>If a mask is not provided then a default mask of only
  ## [`status`](../sites.versions#Version.FIELDS.status) will be used.
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
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("updateMask")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "updateMask", valid_578949
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

proc call*(call_578955: Call_FirebasehostingSitesVersionsPatch_578938;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified metadata for a version. Note that this method will
  ## fail with `FAILED_PRECONDITION` in the event of an invalid state
  ## transition. The only valid transition for a version is currently from a
  ## `CREATED` status to a `FINALIZED` status.
  ## Use [`DeleteVersion`](../sites.versions/delete) to set the status of a
  ## version to `DELETED`.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_FirebasehostingSitesVersionsPatch_578938;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesVersionsPatch
  ## Updates the specified metadata for a version. Note that this method will
  ## fail with `FAILED_PRECONDITION` in the event of an invalid state
  ## transition. The only valid transition for a version is currently from a
  ## `CREATED` status to a `FINALIZED` status.
  ## Use [`DeleteVersion`](../sites.versions/delete) to set the status of a
  ## version to `DELETED`.
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
  ##       : The unique identifier for a version, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## This name is provided in the response body when you call the
  ## [`CreateVersion`](../sites.versions/create) endpoint.
  ##   updateMask: string
  ##             : A set of field names from your [version](../sites.versions) that you want
  ## to update.
  ## <br>A field will be overwritten if, and only if, it's in the mask.
  ## <br>If a mask is not provided then a default mask of only
  ## [`status`](../sites.versions#Version.FIELDS.status) will be used.
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
  add(query_578958, "updateMask", newJString(updateMask))
  if body != nil:
    body_578959 = body
  add(query_578958, "callback", newJString(callback))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, body_578959)

var firebasehostingSitesVersionsPatch* = Call_FirebasehostingSitesVersionsPatch_578938(
    name: "firebasehostingSitesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesVersionsPatch_578939, base: "/",
    url: url_FirebasehostingSitesVersionsPatch_578940, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsDelete_578919 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesVersionsDelete_578921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebasehostingSitesVersionsDelete_578920(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the version to be deleted, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
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

proc call*(call_578934: Call_FirebasehostingSitesVersionsDelete_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified version.
  ## 
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_FirebasehostingSitesVersionsDelete_578919;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesVersionsDelete
  ## Deletes the specified version.
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
  ##       : Required. The name of the version to be deleted, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
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

var firebasehostingSitesVersionsDelete* = Call_FirebasehostingSitesVersionsDelete_578919(
    name: "firebasehostingSitesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebasehostingSitesVersionsDelete_578920, base: "/",
    url: url_FirebasehostingSitesVersionsDelete_578921, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsCreate_578981 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesDomainsCreate_578983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesDomainsCreate_578982(path: JsonNode;
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
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  var valid_578994 = query.getOrDefault("access_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "access_token", valid_578994
  var valid_578995 = query.getOrDefault("upload_protocol")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "upload_protocol", valid_578995
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

proc call*(call_578997: Call_FirebasehostingSitesDomainsCreate_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a domain mapping on the specified site.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_FirebasehostingSitesDomainsCreate_578981;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesDomainsCreate
  ## Creates a domain mapping on the specified site.
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
  ##         : Required. The parent to create the domain association for, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  var body_579001 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "$.xgafv", newJString(Xgafv))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "uploadType", newJString(uploadType))
  add(query_579000, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579001 = body
  add(query_579000, "callback", newJString(callback))
  add(path_578999, "parent", newJString(parent))
  add(query_579000, "fields", newJString(fields))
  add(query_579000, "access_token", newJString(accessToken))
  add(query_579000, "upload_protocol", newJString(uploadProtocol))
  result = call_578998.call(path_578999, query_579000, nil, nil, body_579001)

var firebasehostingSitesDomainsCreate* = Call_FirebasehostingSitesDomainsCreate_578981(
    name: "firebasehostingSitesDomainsCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/domains",
    validator: validate_FirebasehostingSitesDomainsCreate_578982, base: "/",
    url: url_FirebasehostingSitesDomainsCreate_578983, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesDomainsList_578960 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesDomainsList_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesDomainsList_578961(path: JsonNode;
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
  ##           : The page size to return. Defaults to 50.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token from a previous request, if provided.
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

proc call*(call_578977: Call_FirebasehostingSitesDomainsList_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domains for the specified site.
  ## 
  let valid = call_578977.validator(path, query, header, formData, body)
  let scheme = call_578977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578977.url(scheme.get, call_578977.host, call_578977.base,
                         call_578977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578977, url, valid)

proc call*(call_578978: Call_FirebasehostingSitesDomainsList_578960;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesDomainsList
  ## Lists the domains for the specified site.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 50.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent for which to list domains, in the format:
  ## <code>sites/<var>site-name</var></code>
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

var firebasehostingSitesDomainsList* = Call_FirebasehostingSitesDomainsList_578960(
    name: "firebasehostingSitesDomainsList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/domains",
    validator: validate_FirebasehostingSitesDomainsList_578961, base: "/",
    url: url_FirebasehostingSitesDomainsList_578962, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsFilesList_579002 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesVersionsFilesList_579004(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesVersionsFilesList_579003(path: JsonNode;
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
  var valid_579005 = path.getOrDefault("parent")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "parent", valid_579005
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
  ##           : The page size to return. Defaults to 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token from a previous request, if provided. This will be the
  ## encoded version of a firebase.hosting.proto.metadata.ListFilesPageToken.
  ##   callback: JString
  ##           : JSONP
  ##   status: JString
  ##         : The type of files in the version that should be listed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("prettyPrint")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "prettyPrint", valid_579007
  var valid_579008 = query.getOrDefault("oauth_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "oauth_token", valid_579008
  var valid_579009 = query.getOrDefault("$.xgafv")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("1"))
  if valid_579009 != nil:
    section.add "$.xgafv", valid_579009
  var valid_579010 = query.getOrDefault("pageSize")
  valid_579010 = validateParameter(valid_579010, JInt, required = false, default = nil)
  if valid_579010 != nil:
    section.add "pageSize", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("uploadType")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "uploadType", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("pageToken")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "pageToken", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("status")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("STATUS_UNSPECIFIED"))
  if valid_579016 != nil:
    section.add "status", valid_579016
  var valid_579017 = query.getOrDefault("fields")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "fields", valid_579017
  var valid_579018 = query.getOrDefault("access_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "access_token", valid_579018
  var valid_579019 = query.getOrDefault("upload_protocol")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "upload_protocol", valid_579019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579020: Call_FirebasehostingSitesVersionsFilesList_579002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the remaining files to be uploaded for the specified version.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_FirebasehostingSitesVersionsFilesList_579002;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = "";
          status: string = "STATUS_UNSPECIFIED"; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesVersionsFilesList
  ## Lists the remaining files to be uploaded for the specified version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided. This will be the
  ## encoded version of a firebase.hosting.proto.metadata.ListFilesPageToken.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent to list files for, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ##   status: string
  ##         : The type of files in the version that should be listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(query_579023, "pageSize", newJInt(pageSize))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  add(query_579023, "pageToken", newJString(pageToken))
  add(query_579023, "callback", newJString(callback))
  add(path_579022, "parent", newJString(parent))
  add(query_579023, "status", newJString(status))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, nil)

var firebasehostingSitesVersionsFilesList* = Call_FirebasehostingSitesVersionsFilesList_579002(
    name: "firebasehostingSitesVersionsFilesList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/files",
    validator: validate_FirebasehostingSitesVersionsFilesList_579003, base: "/",
    url: url_FirebasehostingSitesVersionsFilesList_579004, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesReleasesCreate_579045 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesReleasesCreate_579047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesReleasesCreate_579046(path: JsonNode;
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
  var valid_579048 = path.getOrDefault("parent")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "parent", valid_579048
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
  ##   versionName: JString
  ##              : The unique identifier for a version, in the format:
  ## <code>/sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## The <var>site-name</var> in this version identifier must match the
  ## <var>site-name</var> in the `parent` parameter.
  ## <br>
  ## <br>This query parameter must be empty if the `type` field in the
  ## request body is `SITE_DISABLE`.
  section = newJObject()
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("$.xgafv")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("1"))
  if valid_579052 != nil:
    section.add "$.xgafv", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("uploadType")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "uploadType", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("callback")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "callback", valid_579056
  var valid_579057 = query.getOrDefault("fields")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "fields", valid_579057
  var valid_579058 = query.getOrDefault("access_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "access_token", valid_579058
  var valid_579059 = query.getOrDefault("upload_protocol")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "upload_protocol", valid_579059
  var valid_579060 = query.getOrDefault("versionName")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "versionName", valid_579060
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

proc call*(call_579062: Call_FirebasehostingSitesReleasesCreate_579045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new release which makes the content of the specified version
  ## actively display on the site.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_FirebasehostingSitesReleasesCreate_579045;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; versionName: string = ""): Recallable =
  ## firebasehostingSitesReleasesCreate
  ## Creates a new release which makes the content of the specified version
  ## actively display on the site.
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
  ##         : The site that the release belongs to, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   versionName: string
  ##              : The unique identifier for a version, in the format:
  ## <code>/sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ## The <var>site-name</var> in this version identifier must match the
  ## <var>site-name</var> in the `parent` parameter.
  ## <br>
  ## <br>This query parameter must be empty if the `type` field in the
  ## request body is `SITE_DISABLE`.
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(path_579064, "parent", newJString(parent))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  add(query_579065, "versionName", newJString(versionName))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var firebasehostingSitesReleasesCreate* = Call_FirebasehostingSitesReleasesCreate_579045(
    name: "firebasehostingSitesReleasesCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/releases",
    validator: validate_FirebasehostingSitesReleasesCreate_579046, base: "/",
    url: url_FirebasehostingSitesReleasesCreate_579047, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesReleasesList_579024 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesReleasesList_579026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesReleasesList_579025(path: JsonNode;
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
  var valid_579027 = path.getOrDefault("parent")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "parent", valid_579027
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
  ##           : The page size to return. Defaults to 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token from a previous request, if provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("pageSize")
  valid_579032 = validateParameter(valid_579032, JInt, required = false, default = nil)
  if valid_579032 != nil:
    section.add "pageSize", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("pageToken")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "pageToken", valid_579036
  var valid_579037 = query.getOrDefault("callback")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "callback", valid_579037
  var valid_579038 = query.getOrDefault("fields")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "fields", valid_579038
  var valid_579039 = query.getOrDefault("access_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "access_token", valid_579039
  var valid_579040 = query.getOrDefault("upload_protocol")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "upload_protocol", valid_579040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579041: Call_FirebasehostingSitesReleasesList_579024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the releases that have been created on the specified site.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_FirebasehostingSitesReleasesList_579024;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesReleasesList
  ## Lists the releases that have been created on the specified site.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The page size to return. Defaults to 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token from a previous request, if provided.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent for which to list files, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "pageSize", newJInt(pageSize))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(query_579044, "pageToken", newJString(pageToken))
  add(query_579044, "callback", newJString(callback))
  add(path_579043, "parent", newJString(parent))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, nil)

var firebasehostingSitesReleasesList* = Call_FirebasehostingSitesReleasesList_579024(
    name: "firebasehostingSitesReleasesList", meth: HttpMethod.HttpGet,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/releases",
    validator: validate_FirebasehostingSitesReleasesList_579025, base: "/",
    url: url_FirebasehostingSitesReleasesList_579026, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsCreate_579067 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesVersionsCreate_579069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesVersionsCreate_579068(path: JsonNode;
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
  var valid_579070 = path.getOrDefault("parent")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "parent", valid_579070
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
  ##   versionId: JString
  ##            : A unique id for the new version. This is only specified for legacy version
  ## creations.
  ##   callback: JString
  ##           : JSONP
  ##   sizeBytes: JString
  ##            : The self-reported size of the version. This value is used for a pre-emptive
  ## quota check for legacy version uploads.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("$.xgafv")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("1"))
  if valid_579074 != nil:
    section.add "$.xgafv", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("uploadType")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "uploadType", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("versionId")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "versionId", valid_579078
  var valid_579079 = query.getOrDefault("callback")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "callback", valid_579079
  var valid_579080 = query.getOrDefault("sizeBytes")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "sizeBytes", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  var valid_579082 = query.getOrDefault("access_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "access_token", valid_579082
  var valid_579083 = query.getOrDefault("upload_protocol")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "upload_protocol", valid_579083
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

proc call*(call_579085: Call_FirebasehostingSitesVersionsCreate_579067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new version for a site.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_FirebasehostingSitesVersionsCreate_579067;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; versionId: string = "";
          body: JsonNode = nil; callback: string = ""; sizeBytes: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesVersionsCreate
  ## Creates a new version for a site.
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
  ##   versionId: string
  ##            : A unique id for the new version. This is only specified for legacy version
  ## creations.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent to create the version for, in the format:
  ## <code>sites/<var>site-name</var></code>
  ##   sizeBytes: string
  ##            : The self-reported size of the version. This value is used for a pre-emptive
  ## quota check for legacy version uploads.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  var body_579089 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(query_579088, "versionId", newJString(versionId))
  if body != nil:
    body_579089 = body
  add(query_579088, "callback", newJString(callback))
  add(path_579087, "parent", newJString(parent))
  add(query_579088, "sizeBytes", newJString(sizeBytes))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579086.call(path_579087, query_579088, nil, nil, body_579089)

var firebasehostingSitesVersionsCreate* = Call_FirebasehostingSitesVersionsCreate_579067(
    name: "firebasehostingSitesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_FirebasehostingSitesVersionsCreate_579068, base: "/",
    url: url_FirebasehostingSitesVersionsCreate_579069, schemes: {Scheme.Https})
type
  Call_FirebasehostingSitesVersionsPopulateFiles_579090 = ref object of OpenApiRestCall_578339
proc url_FirebasehostingSitesVersionsPopulateFiles_579092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebasehostingSitesVersionsPopulateFiles_579091(path: JsonNode;
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
  var valid_579093 = path.getOrDefault("parent")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "parent", valid_579093
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
  var valid_579094 = query.getOrDefault("key")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "key", valid_579094
  var valid_579095 = query.getOrDefault("prettyPrint")
  valid_579095 = validateParameter(valid_579095, JBool, required = false,
                                 default = newJBool(true))
  if valid_579095 != nil:
    section.add "prettyPrint", valid_579095
  var valid_579096 = query.getOrDefault("oauth_token")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "oauth_token", valid_579096
  var valid_579097 = query.getOrDefault("$.xgafv")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("1"))
  if valid_579097 != nil:
    section.add "$.xgafv", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("uploadType")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "uploadType", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("callback")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "callback", valid_579101
  var valid_579102 = query.getOrDefault("fields")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "fields", valid_579102
  var valid_579103 = query.getOrDefault("access_token")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "access_token", valid_579103
  var valid_579104 = query.getOrDefault("upload_protocol")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "upload_protocol", valid_579104
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

proc call*(call_579106: Call_FirebasehostingSitesVersionsPopulateFiles_579090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds content files to a version.
  ## 
  let valid = call_579106.validator(path, query, header, formData, body)
  let scheme = call_579106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579106.url(scheme.get, call_579106.host, call_579106.base,
                         call_579106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579106, url, valid)

proc call*(call_579107: Call_FirebasehostingSitesVersionsPopulateFiles_579090;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebasehostingSitesVersionsPopulateFiles
  ## Adds content files to a version.
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
  ##         : Required. The version to add files to, in the format:
  ## <code>sites/<var>site-name</var>/versions/<var>versionID</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579108 = newJObject()
  var query_579109 = newJObject()
  var body_579110 = newJObject()
  add(query_579109, "key", newJString(key))
  add(query_579109, "prettyPrint", newJBool(prettyPrint))
  add(query_579109, "oauth_token", newJString(oauthToken))
  add(query_579109, "$.xgafv", newJString(Xgafv))
  add(query_579109, "alt", newJString(alt))
  add(query_579109, "uploadType", newJString(uploadType))
  add(query_579109, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579110 = body
  add(query_579109, "callback", newJString(callback))
  add(path_579108, "parent", newJString(parent))
  add(query_579109, "fields", newJString(fields))
  add(query_579109, "access_token", newJString(accessToken))
  add(query_579109, "upload_protocol", newJString(uploadProtocol))
  result = call_579107.call(path_579108, query_579109, nil, nil, body_579110)

var firebasehostingSitesVersionsPopulateFiles* = Call_FirebasehostingSitesVersionsPopulateFiles_579090(
    name: "firebasehostingSitesVersionsPopulateFiles", meth: HttpMethod.HttpPost,
    host: "firebasehosting.googleapis.com",
    route: "/v1beta1/{parent}:populateFiles",
    validator: validate_FirebasehostingSitesVersionsPopulateFiles_579091,
    base: "/", url: url_FirebasehostingSitesVersionsPopulateFiles_579092,
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
