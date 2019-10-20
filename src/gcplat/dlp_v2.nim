
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides methods for detection, risk analysis, and de-identification of privacy-sensitive fragments in text, images, and Google Cloud Platform storage repositories.
## 
## https://cloud.google.com/dlp/docs/
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "dlp"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_578619 = ref object of OpenApiRestCall_578348
proc url_DlpInfoTypesList_578621(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInfoTypesList_578620(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   location: JString
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("filter")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "filter", valid_578753
  var valid_578754 = query.getOrDefault("location")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "location", valid_578754
  var valid_578755 = query.getOrDefault("callback")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "callback", valid_578755
  var valid_578756 = query.getOrDefault("languageCode")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "languageCode", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  var valid_578758 = query.getOrDefault("access_token")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "access_token", valid_578758
  var valid_578759 = query.getOrDefault("upload_protocol")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "upload_protocol", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_DlpInfoTypesList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_DlpInfoTypesList_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; location: string = ""; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   location: string
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "$.xgafv", newJString(Xgafv))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "uploadType", newJString(uploadType))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "filter", newJString(filter))
  add(query_578854, "location", newJString(location))
  add(query_578854, "callback", newJString(callback))
  add(query_578854, "languageCode", newJString(languageCode))
  add(query_578854, "fields", newJString(fields))
  add(query_578854, "access_token", newJString(accessToken))
  add(query_578854, "upload_protocol", newJString(uploadProtocol))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_578619(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com", route: "/v2/infoTypes",
    validator: validate_DlpInfoTypesList_578620, base: "/",
    url: url_DlpInfoTypesList_578621, schemes: {Scheme.Https})
type
  Call_DlpLocationsInfoTypes_578894 = ref object of OpenApiRestCall_578348
proc url_DlpLocationsInfoTypes_578896(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpLocationsInfoTypes_578895(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_578911 = path.getOrDefault("location")
  valid_578911 = validateParameter(valid_578911, JString, required = true,
                                 default = nil)
  if valid_578911 != nil:
    section.add "location", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("$.xgafv")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("1"))
  if valid_578915 != nil:
    section.add "$.xgafv", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("uploadType")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "uploadType", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("callback")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "callback", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
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

proc call*(call_578924: Call_DlpLocationsInfoTypes_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_DlpLocationsInfoTypes_578894; location: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpLocationsInfoTypes
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   location: string (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  var body_578928 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(path_578926, "location", newJString(location))
  if body != nil:
    body_578928 = body
  add(query_578927, "callback", newJString(callback))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, body_578928)

var dlpLocationsInfoTypes* = Call_DlpLocationsInfoTypes_578894(
    name: "dlpLocationsInfoTypes", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/locations/{location}/infoTypes",
    validator: validate_DlpLocationsInfoTypes_578895, base: "/",
    url: url_DlpLocationsInfoTypes_578896, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesGet_578929 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsInspectTemplatesGet_578931(protocol: Scheme; host: string;
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

proc validate_DlpOrganizationsInspectTemplatesGet_578930(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578932 = path.getOrDefault("name")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "name", valid_578932
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
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  var valid_578942 = query.getOrDefault("access_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "access_token", valid_578942
  var valid_578943 = query.getOrDefault("upload_protocol")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "upload_protocol", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_DlpOrganizationsInspectTemplatesGet_578929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_DlpOrganizationsInspectTemplatesGet_578929;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesGet
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##       : Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(path_578946, "name", newJString(name))
  add(query_578947, "callback", newJString(callback))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var dlpOrganizationsInspectTemplatesGet* = Call_DlpOrganizationsInspectTemplatesGet_578929(
    name: "dlpOrganizationsInspectTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesGet_578930, base: "/",
    url: url_DlpOrganizationsInspectTemplatesGet_578931, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesPatch_578967 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsInspectTemplatesPatch_578969(protocol: Scheme;
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

proc validate_DlpOrganizationsInspectTemplatesPatch_578968(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578970 = path.getOrDefault("name")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "name", valid_578970
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
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("$.xgafv")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("1"))
  if valid_578974 != nil:
    section.add "$.xgafv", valid_578974
  var valid_578975 = query.getOrDefault("alt")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("json"))
  if valid_578975 != nil:
    section.add "alt", valid_578975
  var valid_578976 = query.getOrDefault("uploadType")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "uploadType", valid_578976
  var valid_578977 = query.getOrDefault("quotaUser")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "quotaUser", valid_578977
  var valid_578978 = query.getOrDefault("callback")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "callback", valid_578978
  var valid_578979 = query.getOrDefault("fields")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "fields", valid_578979
  var valid_578980 = query.getOrDefault("access_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "access_token", valid_578980
  var valid_578981 = query.getOrDefault("upload_protocol")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "upload_protocol", valid_578981
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

proc call*(call_578983: Call_DlpOrganizationsInspectTemplatesPatch_578967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_DlpOrganizationsInspectTemplatesPatch_578967;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesPatch
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##       : Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  var body_578987 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(query_578986, "$.xgafv", newJString(Xgafv))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "uploadType", newJString(uploadType))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(path_578985, "name", newJString(name))
  if body != nil:
    body_578987 = body
  add(query_578986, "callback", newJString(callback))
  add(query_578986, "fields", newJString(fields))
  add(query_578986, "access_token", newJString(accessToken))
  add(query_578986, "upload_protocol", newJString(uploadProtocol))
  result = call_578984.call(path_578985, query_578986, nil, nil, body_578987)

var dlpOrganizationsInspectTemplatesPatch* = Call_DlpOrganizationsInspectTemplatesPatch_578967(
    name: "dlpOrganizationsInspectTemplatesPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesPatch_578968, base: "/",
    url: url_DlpOrganizationsInspectTemplatesPatch_578969, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesDelete_578948 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsInspectTemplatesDelete_578950(protocol: Scheme;
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

proc validate_DlpOrganizationsInspectTemplatesDelete_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578951 = path.getOrDefault("name")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "name", valid_578951
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
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("callback")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "callback", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  var valid_578961 = query.getOrDefault("access_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "access_token", valid_578961
  var valid_578962 = query.getOrDefault("upload_protocol")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "upload_protocol", valid_578962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578963: Call_DlpOrganizationsInspectTemplatesDelete_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_DlpOrganizationsInspectTemplatesDelete_578948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesDelete
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##       : Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "$.xgafv", newJString(Xgafv))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "uploadType", newJString(uploadType))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(path_578965, "name", newJString(name))
  add(query_578966, "callback", newJString(callback))
  add(query_578966, "fields", newJString(fields))
  add(query_578966, "access_token", newJString(accessToken))
  add(query_578966, "upload_protocol", newJString(uploadProtocol))
  result = call_578964.call(path_578965, query_578966, nil, nil, nil)

var dlpOrganizationsInspectTemplatesDelete* = Call_DlpOrganizationsInspectTemplatesDelete_578948(
    name: "dlpOrganizationsInspectTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesDelete_578949, base: "/",
    url: url_DlpOrganizationsInspectTemplatesDelete_578950,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersActivate_578988 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersActivate_578990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersActivate_578989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578991 = path.getOrDefault("name")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "name", valid_578991
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
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("$.xgafv")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("1"))
  if valid_578995 != nil:
    section.add "$.xgafv", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("uploadType")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "uploadType", valid_578997
  var valid_578998 = query.getOrDefault("quotaUser")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "quotaUser", valid_578998
  var valid_578999 = query.getOrDefault("callback")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "callback", valid_578999
  var valid_579000 = query.getOrDefault("fields")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "fields", valid_579000
  var valid_579001 = query.getOrDefault("access_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "access_token", valid_579001
  var valid_579002 = query.getOrDefault("upload_protocol")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "upload_protocol", valid_579002
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

proc call*(call_579004: Call_DlpProjectsJobTriggersActivate_578988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  let valid = call_579004.validator(path, query, header, formData, body)
  let scheme = call_579004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579004.url(scheme.get, call_579004.host, call_579004.base,
                         call_579004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579004, url, valid)

proc call*(call_579005: Call_DlpProjectsJobTriggersActivate_578988; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersActivate
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
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
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579006 = newJObject()
  var query_579007 = newJObject()
  var body_579008 = newJObject()
  add(query_579007, "key", newJString(key))
  add(query_579007, "prettyPrint", newJBool(prettyPrint))
  add(query_579007, "oauth_token", newJString(oauthToken))
  add(query_579007, "$.xgafv", newJString(Xgafv))
  add(query_579007, "alt", newJString(alt))
  add(query_579007, "uploadType", newJString(uploadType))
  add(query_579007, "quotaUser", newJString(quotaUser))
  add(path_579006, "name", newJString(name))
  if body != nil:
    body_579008 = body
  add(query_579007, "callback", newJString(callback))
  add(query_579007, "fields", newJString(fields))
  add(query_579007, "access_token", newJString(accessToken))
  add(query_579007, "upload_protocol", newJString(uploadProtocol))
  result = call_579005.call(path_579006, query_579007, nil, nil, body_579008)

var dlpProjectsJobTriggersActivate* = Call_DlpProjectsJobTriggersActivate_578988(
    name: "dlpProjectsJobTriggersActivate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:activate",
    validator: validate_DlpProjectsJobTriggersActivate_578989, base: "/",
    url: url_DlpProjectsJobTriggersActivate_578990, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_579009 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDlpJobsCancel_579011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_DlpProjectsDlpJobsCancel_579010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579012 = path.getOrDefault("name")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "name", valid_579012
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
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("$.xgafv")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("1"))
  if valid_579016 != nil:
    section.add "$.xgafv", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("uploadType")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "uploadType", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("access_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "access_token", valid_579022
  var valid_579023 = query.getOrDefault("upload_protocol")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "upload_protocol", valid_579023
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

proc call*(call_579025: Call_DlpProjectsDlpJobsCancel_579009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_DlpProjectsDlpJobsCancel_579009; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
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
  ##       : The name of the DlpJob resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  var body_579029 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "$.xgafv", newJString(Xgafv))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "uploadType", newJString(uploadType))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(path_579027, "name", newJString(name))
  if body != nil:
    body_579029 = body
  add(query_579028, "callback", newJString(callback))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "access_token", newJString(accessToken))
  add(query_579028, "upload_protocol", newJString(uploadProtocol))
  result = call_579026.call(path_579027, query_579028, nil, nil, body_579029)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_579009(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_579010, base: "/",
    url: url_DlpProjectsDlpJobsCancel_579011, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_579030 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentDeidentify_579032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_579031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579033 = path.getOrDefault("parent")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "parent", valid_579033
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
  var valid_579034 = query.getOrDefault("key")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "key", valid_579034
  var valid_579035 = query.getOrDefault("prettyPrint")
  valid_579035 = validateParameter(valid_579035, JBool, required = false,
                                 default = newJBool(true))
  if valid_579035 != nil:
    section.add "prettyPrint", valid_579035
  var valid_579036 = query.getOrDefault("oauth_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "oauth_token", valid_579036
  var valid_579037 = query.getOrDefault("$.xgafv")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("1"))
  if valid_579037 != nil:
    section.add "$.xgafv", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("uploadType")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "uploadType", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("callback")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "callback", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  var valid_579043 = query.getOrDefault("access_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "access_token", valid_579043
  var valid_579044 = query.getOrDefault("upload_protocol")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "upload_protocol", valid_579044
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

proc call*(call_579046: Call_DlpProjectsContentDeidentify_579030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_DlpProjectsContentDeidentify_579030; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  var body_579050 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(query_579049, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579050 = body
  add(query_579049, "callback", newJString(callback))
  add(path_579048, "parent", newJString(parent))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  result = call_579047.call(path_579048, query_579049, nil, nil, body_579050)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_579030(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_579031, base: "/",
    url: url_DlpProjectsContentDeidentify_579032, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_579051 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentInspect_579053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_579052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579054 = path.getOrDefault("parent")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "parent", valid_579054
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
  var valid_579055 = query.getOrDefault("key")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "key", valid_579055
  var valid_579056 = query.getOrDefault("prettyPrint")
  valid_579056 = validateParameter(valid_579056, JBool, required = false,
                                 default = newJBool(true))
  if valid_579056 != nil:
    section.add "prettyPrint", valid_579056
  var valid_579057 = query.getOrDefault("oauth_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "oauth_token", valid_579057
  var valid_579058 = query.getOrDefault("$.xgafv")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("1"))
  if valid_579058 != nil:
    section.add "$.xgafv", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("uploadType")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "uploadType", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("callback")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "callback", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  var valid_579064 = query.getOrDefault("access_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "access_token", valid_579064
  var valid_579065 = query.getOrDefault("upload_protocol")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "upload_protocol", valid_579065
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

proc call*(call_579067: Call_DlpProjectsContentInspect_579051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_DlpProjectsContentInspect_579051; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
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
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  var body_579071 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(query_579070, "$.xgafv", newJString(Xgafv))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "uploadType", newJString(uploadType))
  add(query_579070, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579071 = body
  add(query_579070, "callback", newJString(callback))
  add(path_579069, "parent", newJString(parent))
  add(query_579070, "fields", newJString(fields))
  add(query_579070, "access_token", newJString(accessToken))
  add(query_579070, "upload_protocol", newJString(uploadProtocol))
  result = call_579068.call(path_579069, query_579070, nil, nil, body_579071)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_579051(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_579052, base: "/",
    url: url_DlpProjectsContentInspect_579053, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_579072 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentReidentify_579074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_579073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579075 = path.getOrDefault("parent")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "parent", valid_579075
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
  var valid_579076 = query.getOrDefault("key")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "key", valid_579076
  var valid_579077 = query.getOrDefault("prettyPrint")
  valid_579077 = validateParameter(valid_579077, JBool, required = false,
                                 default = newJBool(true))
  if valid_579077 != nil:
    section.add "prettyPrint", valid_579077
  var valid_579078 = query.getOrDefault("oauth_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "oauth_token", valid_579078
  var valid_579079 = query.getOrDefault("$.xgafv")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("1"))
  if valid_579079 != nil:
    section.add "$.xgafv", valid_579079
  var valid_579080 = query.getOrDefault("alt")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("json"))
  if valid_579080 != nil:
    section.add "alt", valid_579080
  var valid_579081 = query.getOrDefault("uploadType")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "uploadType", valid_579081
  var valid_579082 = query.getOrDefault("quotaUser")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "quotaUser", valid_579082
  var valid_579083 = query.getOrDefault("callback")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "callback", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  var valid_579085 = query.getOrDefault("access_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "access_token", valid_579085
  var valid_579086 = query.getOrDefault("upload_protocol")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "upload_protocol", valid_579086
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

proc call*(call_579088: Call_DlpProjectsContentReidentify_579072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_579088.validator(path, query, header, formData, body)
  let scheme = call_579088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579088.url(scheme.get, call_579088.host, call_579088.base,
                         call_579088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579088, url, valid)

proc call*(call_579089: Call_DlpProjectsContentReidentify_579072; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##         : The parent resource name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579090 = newJObject()
  var query_579091 = newJObject()
  var body_579092 = newJObject()
  add(query_579091, "key", newJString(key))
  add(query_579091, "prettyPrint", newJBool(prettyPrint))
  add(query_579091, "oauth_token", newJString(oauthToken))
  add(query_579091, "$.xgafv", newJString(Xgafv))
  add(query_579091, "alt", newJString(alt))
  add(query_579091, "uploadType", newJString(uploadType))
  add(query_579091, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579092 = body
  add(query_579091, "callback", newJString(callback))
  add(path_579090, "parent", newJString(parent))
  add(query_579091, "fields", newJString(fields))
  add(query_579091, "access_token", newJString(accessToken))
  add(query_579091, "upload_protocol", newJString(uploadProtocol))
  result = call_579089.call(path_579090, query_579091, nil, nil, body_579092)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_579072(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_579073, base: "/",
    url: url_DlpProjectsContentReidentify_579074, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesCreate_579115 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsDeidentifyTemplatesCreate_579117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesCreate_579116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579118 = path.getOrDefault("parent")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "parent", valid_579118
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
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("$.xgafv")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("1"))
  if valid_579122 != nil:
    section.add "$.xgafv", valid_579122
  var valid_579123 = query.getOrDefault("alt")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("json"))
  if valid_579123 != nil:
    section.add "alt", valid_579123
  var valid_579124 = query.getOrDefault("uploadType")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "uploadType", valid_579124
  var valid_579125 = query.getOrDefault("quotaUser")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "quotaUser", valid_579125
  var valid_579126 = query.getOrDefault("callback")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "callback", valid_579126
  var valid_579127 = query.getOrDefault("fields")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "fields", valid_579127
  var valid_579128 = query.getOrDefault("access_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "access_token", valid_579128
  var valid_579129 = query.getOrDefault("upload_protocol")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "upload_protocol", valid_579129
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

proc call*(call_579131: Call_DlpOrganizationsDeidentifyTemplatesCreate_579115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_DlpOrganizationsDeidentifyTemplatesCreate_579115;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesCreate
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
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
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  var body_579135 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(query_579134, "$.xgafv", newJString(Xgafv))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "uploadType", newJString(uploadType))
  add(query_579134, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579135 = body
  add(query_579134, "callback", newJString(callback))
  add(path_579133, "parent", newJString(parent))
  add(query_579134, "fields", newJString(fields))
  add(query_579134, "access_token", newJString(accessToken))
  add(query_579134, "upload_protocol", newJString(uploadProtocol))
  result = call_579132.call(path_579133, query_579134, nil, nil, body_579135)

var dlpOrganizationsDeidentifyTemplatesCreate* = Call_DlpOrganizationsDeidentifyTemplatesCreate_579115(
    name: "dlpOrganizationsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesCreate_579116,
    base: "/", url: url_DlpOrganizationsDeidentifyTemplatesCreate_579117,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesList_579093 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsDeidentifyTemplatesList_579095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesList_579094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579096 = path.getOrDefault("parent")
  valid_579096 = validateParameter(valid_579096, JString, required = true,
                                 default = nil)
  if valid_579096 != nil:
    section.add "parent", valid_579096
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
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579097 = query.getOrDefault("key")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "key", valid_579097
  var valid_579098 = query.getOrDefault("prettyPrint")
  valid_579098 = validateParameter(valid_579098, JBool, required = false,
                                 default = newJBool(true))
  if valid_579098 != nil:
    section.add "prettyPrint", valid_579098
  var valid_579099 = query.getOrDefault("oauth_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "oauth_token", valid_579099
  var valid_579100 = query.getOrDefault("$.xgafv")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("1"))
  if valid_579100 != nil:
    section.add "$.xgafv", valid_579100
  var valid_579101 = query.getOrDefault("pageSize")
  valid_579101 = validateParameter(valid_579101, JInt, required = false, default = nil)
  if valid_579101 != nil:
    section.add "pageSize", valid_579101
  var valid_579102 = query.getOrDefault("alt")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("json"))
  if valid_579102 != nil:
    section.add "alt", valid_579102
  var valid_579103 = query.getOrDefault("uploadType")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "uploadType", valid_579103
  var valid_579104 = query.getOrDefault("quotaUser")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "quotaUser", valid_579104
  var valid_579105 = query.getOrDefault("orderBy")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "orderBy", valid_579105
  var valid_579106 = query.getOrDefault("pageToken")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "pageToken", valid_579106
  var valid_579107 = query.getOrDefault("callback")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "callback", valid_579107
  var valid_579108 = query.getOrDefault("fields")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "fields", valid_579108
  var valid_579109 = query.getOrDefault("access_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "access_token", valid_579109
  var valid_579110 = query.getOrDefault("upload_protocol")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "upload_protocol", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_DlpOrganizationsDeidentifyTemplatesList_579093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_DlpOrganizationsDeidentifyTemplatesList_579093;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesList
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "pageSize", newJInt(pageSize))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(query_579114, "orderBy", newJString(orderBy))
  add(query_579114, "pageToken", newJString(pageToken))
  add(query_579114, "callback", newJString(callback))
  add(path_579113, "parent", newJString(parent))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var dlpOrganizationsDeidentifyTemplatesList* = Call_DlpOrganizationsDeidentifyTemplatesList_579093(
    name: "dlpOrganizationsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesList_579094, base: "/",
    url: url_DlpOrganizationsDeidentifyTemplatesList_579095,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCreate_579160 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDlpJobsCreate_579162(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCreate_579161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579163 = path.getOrDefault("parent")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "parent", valid_579163
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
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("prettyPrint")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "prettyPrint", valid_579165
  var valid_579166 = query.getOrDefault("oauth_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "oauth_token", valid_579166
  var valid_579167 = query.getOrDefault("$.xgafv")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("1"))
  if valid_579167 != nil:
    section.add "$.xgafv", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("uploadType")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "uploadType", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("callback")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "callback", valid_579171
  var valid_579172 = query.getOrDefault("fields")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "fields", valid_579172
  var valid_579173 = query.getOrDefault("access_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "access_token", valid_579173
  var valid_579174 = query.getOrDefault("upload_protocol")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "upload_protocol", valid_579174
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

proc call*(call_579176: Call_DlpProjectsDlpJobsCreate_579160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_579176.validator(path, query, header, formData, body)
  let scheme = call_579176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579176.url(scheme.get, call_579176.host, call_579176.base,
                         call_579176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579176, url, valid)

proc call*(call_579177: Call_DlpProjectsDlpJobsCreate_579160; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsCreate
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579178 = newJObject()
  var query_579179 = newJObject()
  var body_579180 = newJObject()
  add(query_579179, "key", newJString(key))
  add(query_579179, "prettyPrint", newJBool(prettyPrint))
  add(query_579179, "oauth_token", newJString(oauthToken))
  add(query_579179, "$.xgafv", newJString(Xgafv))
  add(query_579179, "alt", newJString(alt))
  add(query_579179, "uploadType", newJString(uploadType))
  add(query_579179, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579180 = body
  add(query_579179, "callback", newJString(callback))
  add(path_579178, "parent", newJString(parent))
  add(query_579179, "fields", newJString(fields))
  add(query_579179, "access_token", newJString(accessToken))
  add(query_579179, "upload_protocol", newJString(uploadProtocol))
  result = call_579177.call(path_579178, query_579179, nil, nil, body_579180)

var dlpProjectsDlpJobsCreate* = Call_DlpProjectsDlpJobsCreate_579160(
    name: "dlpProjectsDlpJobsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsCreate_579161, base: "/",
    url: url_DlpProjectsDlpJobsCreate_579162, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_579136 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDlpJobsList_579138(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_579137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579139 = path.getOrDefault("parent")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "parent", valid_579139
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   type: JString
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579140 = query.getOrDefault("key")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "key", valid_579140
  var valid_579141 = query.getOrDefault("prettyPrint")
  valid_579141 = validateParameter(valid_579141, JBool, required = false,
                                 default = newJBool(true))
  if valid_579141 != nil:
    section.add "prettyPrint", valid_579141
  var valid_579142 = query.getOrDefault("oauth_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "oauth_token", valid_579142
  var valid_579143 = query.getOrDefault("$.xgafv")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("1"))
  if valid_579143 != nil:
    section.add "$.xgafv", valid_579143
  var valid_579144 = query.getOrDefault("pageSize")
  valid_579144 = validateParameter(valid_579144, JInt, required = false, default = nil)
  if valid_579144 != nil:
    section.add "pageSize", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("uploadType")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "uploadType", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("orderBy")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "orderBy", valid_579148
  var valid_579149 = query.getOrDefault("type")
  valid_579149 = validateParameter(valid_579149, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_579149 != nil:
    section.add "type", valid_579149
  var valid_579150 = query.getOrDefault("filter")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "filter", valid_579150
  var valid_579151 = query.getOrDefault("pageToken")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "pageToken", valid_579151
  var valid_579152 = query.getOrDefault("callback")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "callback", valid_579152
  var valid_579153 = query.getOrDefault("fields")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "fields", valid_579153
  var valid_579154 = query.getOrDefault("access_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "access_token", valid_579154
  var valid_579155 = query.getOrDefault("upload_protocol")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "upload_protocol", valid_579155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579156: Call_DlpProjectsDlpJobsList_579136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_579156.validator(path, query, header, formData, body)
  let scheme = call_579156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579156.url(scheme.get, call_579156.host, call_579156.base,
                         call_579156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579156, url, valid)

proc call*(call_579157: Call_DlpProjectsDlpJobsList_579136; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   type: string
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579158 = newJObject()
  var query_579159 = newJObject()
  add(query_579159, "key", newJString(key))
  add(query_579159, "prettyPrint", newJBool(prettyPrint))
  add(query_579159, "oauth_token", newJString(oauthToken))
  add(query_579159, "$.xgafv", newJString(Xgafv))
  add(query_579159, "pageSize", newJInt(pageSize))
  add(query_579159, "alt", newJString(alt))
  add(query_579159, "uploadType", newJString(uploadType))
  add(query_579159, "quotaUser", newJString(quotaUser))
  add(query_579159, "orderBy", newJString(orderBy))
  add(query_579159, "type", newJString(`type`))
  add(query_579159, "filter", newJString(filter))
  add(query_579159, "pageToken", newJString(pageToken))
  add(query_579159, "callback", newJString(callback))
  add(path_579158, "parent", newJString(parent))
  add(query_579159, "fields", newJString(fields))
  add(query_579159, "access_token", newJString(accessToken))
  add(query_579159, "upload_protocol", newJString(uploadProtocol))
  result = call_579157.call(path_579158, query_579159, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_579136(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_579137, base: "/",
    url: url_DlpProjectsDlpJobsList_579138, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_579181 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsImageRedact_579183(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_579182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579184 = path.getOrDefault("parent")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "parent", valid_579184
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
  var valid_579185 = query.getOrDefault("key")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "key", valid_579185
  var valid_579186 = query.getOrDefault("prettyPrint")
  valid_579186 = validateParameter(valid_579186, JBool, required = false,
                                 default = newJBool(true))
  if valid_579186 != nil:
    section.add "prettyPrint", valid_579186
  var valid_579187 = query.getOrDefault("oauth_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "oauth_token", valid_579187
  var valid_579188 = query.getOrDefault("$.xgafv")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("1"))
  if valid_579188 != nil:
    section.add "$.xgafv", valid_579188
  var valid_579189 = query.getOrDefault("alt")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = newJString("json"))
  if valid_579189 != nil:
    section.add "alt", valid_579189
  var valid_579190 = query.getOrDefault("uploadType")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "uploadType", valid_579190
  var valid_579191 = query.getOrDefault("quotaUser")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "quotaUser", valid_579191
  var valid_579192 = query.getOrDefault("callback")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "callback", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  var valid_579194 = query.getOrDefault("access_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "access_token", valid_579194
  var valid_579195 = query.getOrDefault("upload_protocol")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "upload_protocol", valid_579195
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

proc call*(call_579197: Call_DlpProjectsImageRedact_579181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_579197.validator(path, query, header, formData, body)
  let scheme = call_579197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579197.url(scheme.get, call_579197.host, call_579197.base,
                         call_579197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579197, url, valid)

proc call*(call_579198: Call_DlpProjectsImageRedact_579181; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579199 = newJObject()
  var query_579200 = newJObject()
  var body_579201 = newJObject()
  add(query_579200, "key", newJString(key))
  add(query_579200, "prettyPrint", newJBool(prettyPrint))
  add(query_579200, "oauth_token", newJString(oauthToken))
  add(query_579200, "$.xgafv", newJString(Xgafv))
  add(query_579200, "alt", newJString(alt))
  add(query_579200, "uploadType", newJString(uploadType))
  add(query_579200, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579201 = body
  add(query_579200, "callback", newJString(callback))
  add(path_579199, "parent", newJString(parent))
  add(query_579200, "fields", newJString(fields))
  add(query_579200, "access_token", newJString(accessToken))
  add(query_579200, "upload_protocol", newJString(uploadProtocol))
  result = call_579198.call(path_579199, query_579200, nil, nil, body_579201)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_579181(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_579182, base: "/",
    url: url_DlpProjectsImageRedact_579183, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesCreate_579224 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsInspectTemplatesCreate_579226(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesCreate_579225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579227 = path.getOrDefault("parent")
  valid_579227 = validateParameter(valid_579227, JString, required = true,
                                 default = nil)
  if valid_579227 != nil:
    section.add "parent", valid_579227
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
  var valid_579228 = query.getOrDefault("key")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "key", valid_579228
  var valid_579229 = query.getOrDefault("prettyPrint")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(true))
  if valid_579229 != nil:
    section.add "prettyPrint", valid_579229
  var valid_579230 = query.getOrDefault("oauth_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "oauth_token", valid_579230
  var valid_579231 = query.getOrDefault("$.xgafv")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("1"))
  if valid_579231 != nil:
    section.add "$.xgafv", valid_579231
  var valid_579232 = query.getOrDefault("alt")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = newJString("json"))
  if valid_579232 != nil:
    section.add "alt", valid_579232
  var valid_579233 = query.getOrDefault("uploadType")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "uploadType", valid_579233
  var valid_579234 = query.getOrDefault("quotaUser")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "quotaUser", valid_579234
  var valid_579235 = query.getOrDefault("callback")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "callback", valid_579235
  var valid_579236 = query.getOrDefault("fields")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "fields", valid_579236
  var valid_579237 = query.getOrDefault("access_token")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "access_token", valid_579237
  var valid_579238 = query.getOrDefault("upload_protocol")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "upload_protocol", valid_579238
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

proc call*(call_579240: Call_DlpOrganizationsInspectTemplatesCreate_579224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_579240.validator(path, query, header, formData, body)
  let scheme = call_579240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579240.url(scheme.get, call_579240.host, call_579240.base,
                         call_579240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579240, url, valid)

proc call*(call_579241: Call_DlpOrganizationsInspectTemplatesCreate_579224;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesCreate
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579242 = newJObject()
  var query_579243 = newJObject()
  var body_579244 = newJObject()
  add(query_579243, "key", newJString(key))
  add(query_579243, "prettyPrint", newJBool(prettyPrint))
  add(query_579243, "oauth_token", newJString(oauthToken))
  add(query_579243, "$.xgafv", newJString(Xgafv))
  add(query_579243, "alt", newJString(alt))
  add(query_579243, "uploadType", newJString(uploadType))
  add(query_579243, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579244 = body
  add(query_579243, "callback", newJString(callback))
  add(path_579242, "parent", newJString(parent))
  add(query_579243, "fields", newJString(fields))
  add(query_579243, "access_token", newJString(accessToken))
  add(query_579243, "upload_protocol", newJString(uploadProtocol))
  result = call_579241.call(path_579242, query_579243, nil, nil, body_579244)

var dlpOrganizationsInspectTemplatesCreate* = Call_DlpOrganizationsInspectTemplatesCreate_579224(
    name: "dlpOrganizationsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesCreate_579225, base: "/",
    url: url_DlpOrganizationsInspectTemplatesCreate_579226,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesList_579202 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsInspectTemplatesList_579204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesList_579203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579205 = path.getOrDefault("parent")
  valid_579205 = validateParameter(valid_579205, JString, required = true,
                                 default = nil)
  if valid_579205 != nil:
    section.add "parent", valid_579205
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
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579206 = query.getOrDefault("key")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "key", valid_579206
  var valid_579207 = query.getOrDefault("prettyPrint")
  valid_579207 = validateParameter(valid_579207, JBool, required = false,
                                 default = newJBool(true))
  if valid_579207 != nil:
    section.add "prettyPrint", valid_579207
  var valid_579208 = query.getOrDefault("oauth_token")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "oauth_token", valid_579208
  var valid_579209 = query.getOrDefault("$.xgafv")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = newJString("1"))
  if valid_579209 != nil:
    section.add "$.xgafv", valid_579209
  var valid_579210 = query.getOrDefault("pageSize")
  valid_579210 = validateParameter(valid_579210, JInt, required = false, default = nil)
  if valid_579210 != nil:
    section.add "pageSize", valid_579210
  var valid_579211 = query.getOrDefault("alt")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = newJString("json"))
  if valid_579211 != nil:
    section.add "alt", valid_579211
  var valid_579212 = query.getOrDefault("uploadType")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "uploadType", valid_579212
  var valid_579213 = query.getOrDefault("quotaUser")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "quotaUser", valid_579213
  var valid_579214 = query.getOrDefault("orderBy")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "orderBy", valid_579214
  var valid_579215 = query.getOrDefault("pageToken")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "pageToken", valid_579215
  var valid_579216 = query.getOrDefault("callback")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "callback", valid_579216
  var valid_579217 = query.getOrDefault("fields")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fields", valid_579217
  var valid_579218 = query.getOrDefault("access_token")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "access_token", valid_579218
  var valid_579219 = query.getOrDefault("upload_protocol")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "upload_protocol", valid_579219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579220: Call_DlpOrganizationsInspectTemplatesList_579202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_579220.validator(path, query, header, formData, body)
  let scheme = call_579220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579220.url(scheme.get, call_579220.host, call_579220.base,
                         call_579220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579220, url, valid)

proc call*(call_579221: Call_DlpOrganizationsInspectTemplatesList_579202;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesList
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579222 = newJObject()
  var query_579223 = newJObject()
  add(query_579223, "key", newJString(key))
  add(query_579223, "prettyPrint", newJBool(prettyPrint))
  add(query_579223, "oauth_token", newJString(oauthToken))
  add(query_579223, "$.xgafv", newJString(Xgafv))
  add(query_579223, "pageSize", newJInt(pageSize))
  add(query_579223, "alt", newJString(alt))
  add(query_579223, "uploadType", newJString(uploadType))
  add(query_579223, "quotaUser", newJString(quotaUser))
  add(query_579223, "orderBy", newJString(orderBy))
  add(query_579223, "pageToken", newJString(pageToken))
  add(query_579223, "callback", newJString(callback))
  add(path_579222, "parent", newJString(parent))
  add(query_579223, "fields", newJString(fields))
  add(query_579223, "access_token", newJString(accessToken))
  add(query_579223, "upload_protocol", newJString(uploadProtocol))
  result = call_579221.call(path_579222, query_579223, nil, nil, nil)

var dlpOrganizationsInspectTemplatesList* = Call_DlpOrganizationsInspectTemplatesList_579202(
    name: "dlpOrganizationsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesList_579203, base: "/",
    url: url_DlpOrganizationsInspectTemplatesList_579204, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_579268 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersCreate_579270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_579269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579271 = path.getOrDefault("parent")
  valid_579271 = validateParameter(valid_579271, JString, required = true,
                                 default = nil)
  if valid_579271 != nil:
    section.add "parent", valid_579271
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
  var valid_579272 = query.getOrDefault("key")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "key", valid_579272
  var valid_579273 = query.getOrDefault("prettyPrint")
  valid_579273 = validateParameter(valid_579273, JBool, required = false,
                                 default = newJBool(true))
  if valid_579273 != nil:
    section.add "prettyPrint", valid_579273
  var valid_579274 = query.getOrDefault("oauth_token")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "oauth_token", valid_579274
  var valid_579275 = query.getOrDefault("$.xgafv")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("1"))
  if valid_579275 != nil:
    section.add "$.xgafv", valid_579275
  var valid_579276 = query.getOrDefault("alt")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = newJString("json"))
  if valid_579276 != nil:
    section.add "alt", valid_579276
  var valid_579277 = query.getOrDefault("uploadType")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "uploadType", valid_579277
  var valid_579278 = query.getOrDefault("quotaUser")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "quotaUser", valid_579278
  var valid_579279 = query.getOrDefault("callback")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "callback", valid_579279
  var valid_579280 = query.getOrDefault("fields")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "fields", valid_579280
  var valid_579281 = query.getOrDefault("access_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "access_token", valid_579281
  var valid_579282 = query.getOrDefault("upload_protocol")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "upload_protocol", valid_579282
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

proc call*(call_579284: Call_DlpProjectsJobTriggersCreate_579268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_579284.validator(path, query, header, formData, body)
  let scheme = call_579284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579284.url(scheme.get, call_579284.host, call_579284.base,
                         call_579284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579284, url, valid)

proc call*(call_579285: Call_DlpProjectsJobTriggersCreate_579268; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
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
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579286 = newJObject()
  var query_579287 = newJObject()
  var body_579288 = newJObject()
  add(query_579287, "key", newJString(key))
  add(query_579287, "prettyPrint", newJBool(prettyPrint))
  add(query_579287, "oauth_token", newJString(oauthToken))
  add(query_579287, "$.xgafv", newJString(Xgafv))
  add(query_579287, "alt", newJString(alt))
  add(query_579287, "uploadType", newJString(uploadType))
  add(query_579287, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579288 = body
  add(query_579287, "callback", newJString(callback))
  add(path_579286, "parent", newJString(parent))
  add(query_579287, "fields", newJString(fields))
  add(query_579287, "access_token", newJString(accessToken))
  add(query_579287, "upload_protocol", newJString(uploadProtocol))
  result = call_579285.call(path_579286, query_579287, nil, nil, body_579288)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_579268(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_579269, base: "/",
    url: url_DlpProjectsJobTriggersCreate_579270, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_579245 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersList_579247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_579246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579248 = path.getOrDefault("parent")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "parent", valid_579248
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
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579249 = query.getOrDefault("key")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "key", valid_579249
  var valid_579250 = query.getOrDefault("prettyPrint")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(true))
  if valid_579250 != nil:
    section.add "prettyPrint", valid_579250
  var valid_579251 = query.getOrDefault("oauth_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "oauth_token", valid_579251
  var valid_579252 = query.getOrDefault("$.xgafv")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = newJString("1"))
  if valid_579252 != nil:
    section.add "$.xgafv", valid_579252
  var valid_579253 = query.getOrDefault("pageSize")
  valid_579253 = validateParameter(valid_579253, JInt, required = false, default = nil)
  if valid_579253 != nil:
    section.add "pageSize", valid_579253
  var valid_579254 = query.getOrDefault("alt")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = newJString("json"))
  if valid_579254 != nil:
    section.add "alt", valid_579254
  var valid_579255 = query.getOrDefault("uploadType")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "uploadType", valid_579255
  var valid_579256 = query.getOrDefault("quotaUser")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "quotaUser", valid_579256
  var valid_579257 = query.getOrDefault("orderBy")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "orderBy", valid_579257
  var valid_579258 = query.getOrDefault("filter")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "filter", valid_579258
  var valid_579259 = query.getOrDefault("pageToken")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "pageToken", valid_579259
  var valid_579260 = query.getOrDefault("callback")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "callback", valid_579260
  var valid_579261 = query.getOrDefault("fields")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "fields", valid_579261
  var valid_579262 = query.getOrDefault("access_token")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "access_token", valid_579262
  var valid_579263 = query.getOrDefault("upload_protocol")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "upload_protocol", valid_579263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579264: Call_DlpProjectsJobTriggersList_579245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_579264.validator(path, query, header, formData, body)
  let scheme = call_579264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579264.url(scheme.get, call_579264.host, call_579264.base,
                         call_579264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579264, url, valid)

proc call*(call_579265: Call_DlpProjectsJobTriggersList_579245; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579266 = newJObject()
  var query_579267 = newJObject()
  add(query_579267, "key", newJString(key))
  add(query_579267, "prettyPrint", newJBool(prettyPrint))
  add(query_579267, "oauth_token", newJString(oauthToken))
  add(query_579267, "$.xgafv", newJString(Xgafv))
  add(query_579267, "pageSize", newJInt(pageSize))
  add(query_579267, "alt", newJString(alt))
  add(query_579267, "uploadType", newJString(uploadType))
  add(query_579267, "quotaUser", newJString(quotaUser))
  add(query_579267, "orderBy", newJString(orderBy))
  add(query_579267, "filter", newJString(filter))
  add(query_579267, "pageToken", newJString(pageToken))
  add(query_579267, "callback", newJString(callback))
  add(path_579266, "parent", newJString(parent))
  add(query_579267, "fields", newJString(fields))
  add(query_579267, "access_token", newJString(accessToken))
  add(query_579267, "upload_protocol", newJString(uploadProtocol))
  result = call_579265.call(path_579266, query_579267, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_579245(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_579246, base: "/",
    url: url_DlpProjectsJobTriggersList_579247, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentDeidentify_579289 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsLocationsContentDeidentify_579291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentDeidentify_579290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579292 = path.getOrDefault("location")
  valid_579292 = validateParameter(valid_579292, JString, required = true,
                                 default = nil)
  if valid_579292 != nil:
    section.add "location", valid_579292
  var valid_579293 = path.getOrDefault("parent")
  valid_579293 = validateParameter(valid_579293, JString, required = true,
                                 default = nil)
  if valid_579293 != nil:
    section.add "parent", valid_579293
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
  var valid_579294 = query.getOrDefault("key")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "key", valid_579294
  var valid_579295 = query.getOrDefault("prettyPrint")
  valid_579295 = validateParameter(valid_579295, JBool, required = false,
                                 default = newJBool(true))
  if valid_579295 != nil:
    section.add "prettyPrint", valid_579295
  var valid_579296 = query.getOrDefault("oauth_token")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "oauth_token", valid_579296
  var valid_579297 = query.getOrDefault("$.xgafv")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = newJString("1"))
  if valid_579297 != nil:
    section.add "$.xgafv", valid_579297
  var valid_579298 = query.getOrDefault("alt")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = newJString("json"))
  if valid_579298 != nil:
    section.add "alt", valid_579298
  var valid_579299 = query.getOrDefault("uploadType")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "uploadType", valid_579299
  var valid_579300 = query.getOrDefault("quotaUser")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "quotaUser", valid_579300
  var valid_579301 = query.getOrDefault("callback")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "callback", valid_579301
  var valid_579302 = query.getOrDefault("fields")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "fields", valid_579302
  var valid_579303 = query.getOrDefault("access_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "access_token", valid_579303
  var valid_579304 = query.getOrDefault("upload_protocol")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "upload_protocol", valid_579304
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

proc call*(call_579306: Call_DlpProjectsLocationsContentDeidentify_579289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_579306.validator(path, query, header, formData, body)
  let scheme = call_579306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579306.url(scheme.get, call_579306.host, call_579306.base,
                         call_579306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579306, url, valid)

proc call*(call_579307: Call_DlpProjectsLocationsContentDeidentify_579289;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   location: string (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579308 = newJObject()
  var query_579309 = newJObject()
  var body_579310 = newJObject()
  add(query_579309, "key", newJString(key))
  add(query_579309, "prettyPrint", newJBool(prettyPrint))
  add(query_579309, "oauth_token", newJString(oauthToken))
  add(query_579309, "$.xgafv", newJString(Xgafv))
  add(query_579309, "alt", newJString(alt))
  add(query_579309, "uploadType", newJString(uploadType))
  add(query_579309, "quotaUser", newJString(quotaUser))
  add(path_579308, "location", newJString(location))
  if body != nil:
    body_579310 = body
  add(query_579309, "callback", newJString(callback))
  add(path_579308, "parent", newJString(parent))
  add(query_579309, "fields", newJString(fields))
  add(query_579309, "access_token", newJString(accessToken))
  add(query_579309, "upload_protocol", newJString(uploadProtocol))
  result = call_579307.call(path_579308, query_579309, nil, nil, body_579310)

var dlpProjectsLocationsContentDeidentify* = Call_DlpProjectsLocationsContentDeidentify_579289(
    name: "dlpProjectsLocationsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:deidentify",
    validator: validate_DlpProjectsLocationsContentDeidentify_579290, base: "/",
    url: url_DlpProjectsLocationsContentDeidentify_579291, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentInspect_579311 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsLocationsContentInspect_579313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentInspect_579312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579314 = path.getOrDefault("location")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "location", valid_579314
  var valid_579315 = path.getOrDefault("parent")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "parent", valid_579315
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
  var valid_579316 = query.getOrDefault("key")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "key", valid_579316
  var valid_579317 = query.getOrDefault("prettyPrint")
  valid_579317 = validateParameter(valid_579317, JBool, required = false,
                                 default = newJBool(true))
  if valid_579317 != nil:
    section.add "prettyPrint", valid_579317
  var valid_579318 = query.getOrDefault("oauth_token")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "oauth_token", valid_579318
  var valid_579319 = query.getOrDefault("$.xgafv")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = newJString("1"))
  if valid_579319 != nil:
    section.add "$.xgafv", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("uploadType")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "uploadType", valid_579321
  var valid_579322 = query.getOrDefault("quotaUser")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "quotaUser", valid_579322
  var valid_579323 = query.getOrDefault("callback")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "callback", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  var valid_579325 = query.getOrDefault("access_token")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "access_token", valid_579325
  var valid_579326 = query.getOrDefault("upload_protocol")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "upload_protocol", valid_579326
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

proc call*(call_579328: Call_DlpProjectsLocationsContentInspect_579311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_579328.validator(path, query, header, formData, body)
  let scheme = call_579328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579328.url(scheme.get, call_579328.host, call_579328.base,
                         call_579328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579328, url, valid)

proc call*(call_579329: Call_DlpProjectsLocationsContentInspect_579311;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
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
  ##   location: string (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579330 = newJObject()
  var query_579331 = newJObject()
  var body_579332 = newJObject()
  add(query_579331, "key", newJString(key))
  add(query_579331, "prettyPrint", newJBool(prettyPrint))
  add(query_579331, "oauth_token", newJString(oauthToken))
  add(query_579331, "$.xgafv", newJString(Xgafv))
  add(query_579331, "alt", newJString(alt))
  add(query_579331, "uploadType", newJString(uploadType))
  add(query_579331, "quotaUser", newJString(quotaUser))
  add(path_579330, "location", newJString(location))
  if body != nil:
    body_579332 = body
  add(query_579331, "callback", newJString(callback))
  add(path_579330, "parent", newJString(parent))
  add(query_579331, "fields", newJString(fields))
  add(query_579331, "access_token", newJString(accessToken))
  add(query_579331, "upload_protocol", newJString(uploadProtocol))
  result = call_579329.call(path_579330, query_579331, nil, nil, body_579332)

var dlpProjectsLocationsContentInspect* = Call_DlpProjectsLocationsContentInspect_579311(
    name: "dlpProjectsLocationsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:inspect",
    validator: validate_DlpProjectsLocationsContentInspect_579312, base: "/",
    url: url_DlpProjectsLocationsContentInspect_579313, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentReidentify_579333 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsLocationsContentReidentify_579335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentReidentify_579334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579336 = path.getOrDefault("location")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "location", valid_579336
  var valid_579337 = path.getOrDefault("parent")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "parent", valid_579337
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
  var valid_579338 = query.getOrDefault("key")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "key", valid_579338
  var valid_579339 = query.getOrDefault("prettyPrint")
  valid_579339 = validateParameter(valid_579339, JBool, required = false,
                                 default = newJBool(true))
  if valid_579339 != nil:
    section.add "prettyPrint", valid_579339
  var valid_579340 = query.getOrDefault("oauth_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "oauth_token", valid_579340
  var valid_579341 = query.getOrDefault("$.xgafv")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("1"))
  if valid_579341 != nil:
    section.add "$.xgafv", valid_579341
  var valid_579342 = query.getOrDefault("alt")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = newJString("json"))
  if valid_579342 != nil:
    section.add "alt", valid_579342
  var valid_579343 = query.getOrDefault("uploadType")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "uploadType", valid_579343
  var valid_579344 = query.getOrDefault("quotaUser")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "quotaUser", valid_579344
  var valid_579345 = query.getOrDefault("callback")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "callback", valid_579345
  var valid_579346 = query.getOrDefault("fields")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "fields", valid_579346
  var valid_579347 = query.getOrDefault("access_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "access_token", valid_579347
  var valid_579348 = query.getOrDefault("upload_protocol")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "upload_protocol", valid_579348
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

proc call*(call_579350: Call_DlpProjectsLocationsContentReidentify_579333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_579350.validator(path, query, header, formData, body)
  let scheme = call_579350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579350.url(scheme.get, call_579350.host, call_579350.base,
                         call_579350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579350, url, valid)

proc call*(call_579351: Call_DlpProjectsLocationsContentReidentify_579333;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##   location: string (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579352 = newJObject()
  var query_579353 = newJObject()
  var body_579354 = newJObject()
  add(query_579353, "key", newJString(key))
  add(query_579353, "prettyPrint", newJBool(prettyPrint))
  add(query_579353, "oauth_token", newJString(oauthToken))
  add(query_579353, "$.xgafv", newJString(Xgafv))
  add(query_579353, "alt", newJString(alt))
  add(query_579353, "uploadType", newJString(uploadType))
  add(query_579353, "quotaUser", newJString(quotaUser))
  add(path_579352, "location", newJString(location))
  if body != nil:
    body_579354 = body
  add(query_579353, "callback", newJString(callback))
  add(path_579352, "parent", newJString(parent))
  add(query_579353, "fields", newJString(fields))
  add(query_579353, "access_token", newJString(accessToken))
  add(query_579353, "upload_protocol", newJString(uploadProtocol))
  result = call_579351.call(path_579352, query_579353, nil, nil, body_579354)

var dlpProjectsLocationsContentReidentify* = Call_DlpProjectsLocationsContentReidentify_579333(
    name: "dlpProjectsLocationsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:reidentify",
    validator: validate_DlpProjectsLocationsContentReidentify_579334, base: "/",
    url: url_DlpProjectsLocationsContentReidentify_579335, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesCreate_579377 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsStoredInfoTypesCreate_579379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesCreate_579378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579380 = path.getOrDefault("parent")
  valid_579380 = validateParameter(valid_579380, JString, required = true,
                                 default = nil)
  if valid_579380 != nil:
    section.add "parent", valid_579380
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
  var valid_579381 = query.getOrDefault("key")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "key", valid_579381
  var valid_579382 = query.getOrDefault("prettyPrint")
  valid_579382 = validateParameter(valid_579382, JBool, required = false,
                                 default = newJBool(true))
  if valid_579382 != nil:
    section.add "prettyPrint", valid_579382
  var valid_579383 = query.getOrDefault("oauth_token")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "oauth_token", valid_579383
  var valid_579384 = query.getOrDefault("$.xgafv")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = newJString("1"))
  if valid_579384 != nil:
    section.add "$.xgafv", valid_579384
  var valid_579385 = query.getOrDefault("alt")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = newJString("json"))
  if valid_579385 != nil:
    section.add "alt", valid_579385
  var valid_579386 = query.getOrDefault("uploadType")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "uploadType", valid_579386
  var valid_579387 = query.getOrDefault("quotaUser")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "quotaUser", valid_579387
  var valid_579388 = query.getOrDefault("callback")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "callback", valid_579388
  var valid_579389 = query.getOrDefault("fields")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "fields", valid_579389
  var valid_579390 = query.getOrDefault("access_token")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "access_token", valid_579390
  var valid_579391 = query.getOrDefault("upload_protocol")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "upload_protocol", valid_579391
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

proc call*(call_579393: Call_DlpOrganizationsStoredInfoTypesCreate_579377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_579393.validator(path, query, header, formData, body)
  let scheme = call_579393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579393.url(scheme.get, call_579393.host, call_579393.base,
                         call_579393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579393, url, valid)

proc call*(call_579394: Call_DlpOrganizationsStoredInfoTypesCreate_579377;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsStoredInfoTypesCreate
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
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
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579395 = newJObject()
  var query_579396 = newJObject()
  var body_579397 = newJObject()
  add(query_579396, "key", newJString(key))
  add(query_579396, "prettyPrint", newJBool(prettyPrint))
  add(query_579396, "oauth_token", newJString(oauthToken))
  add(query_579396, "$.xgafv", newJString(Xgafv))
  add(query_579396, "alt", newJString(alt))
  add(query_579396, "uploadType", newJString(uploadType))
  add(query_579396, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579397 = body
  add(query_579396, "callback", newJString(callback))
  add(path_579395, "parent", newJString(parent))
  add(query_579396, "fields", newJString(fields))
  add(query_579396, "access_token", newJString(accessToken))
  add(query_579396, "upload_protocol", newJString(uploadProtocol))
  result = call_579394.call(path_579395, query_579396, nil, nil, body_579397)

var dlpOrganizationsStoredInfoTypesCreate* = Call_DlpOrganizationsStoredInfoTypesCreate_579377(
    name: "dlpOrganizationsStoredInfoTypesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesCreate_579378, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesCreate_579379, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesList_579355 = ref object of OpenApiRestCall_578348
proc url_DlpOrganizationsStoredInfoTypesList_579357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesList_579356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579358 = path.getOrDefault("parent")
  valid_579358 = validateParameter(valid_579358, JString, required = true,
                                 default = nil)
  if valid_579358 != nil:
    section.add "parent", valid_579358
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
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579359 = query.getOrDefault("key")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "key", valid_579359
  var valid_579360 = query.getOrDefault("prettyPrint")
  valid_579360 = validateParameter(valid_579360, JBool, required = false,
                                 default = newJBool(true))
  if valid_579360 != nil:
    section.add "prettyPrint", valid_579360
  var valid_579361 = query.getOrDefault("oauth_token")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "oauth_token", valid_579361
  var valid_579362 = query.getOrDefault("$.xgafv")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = newJString("1"))
  if valid_579362 != nil:
    section.add "$.xgafv", valid_579362
  var valid_579363 = query.getOrDefault("pageSize")
  valid_579363 = validateParameter(valid_579363, JInt, required = false, default = nil)
  if valid_579363 != nil:
    section.add "pageSize", valid_579363
  var valid_579364 = query.getOrDefault("alt")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = newJString("json"))
  if valid_579364 != nil:
    section.add "alt", valid_579364
  var valid_579365 = query.getOrDefault("uploadType")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "uploadType", valid_579365
  var valid_579366 = query.getOrDefault("quotaUser")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "quotaUser", valid_579366
  var valid_579367 = query.getOrDefault("orderBy")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "orderBy", valid_579367
  var valid_579368 = query.getOrDefault("pageToken")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "pageToken", valid_579368
  var valid_579369 = query.getOrDefault("callback")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "callback", valid_579369
  var valid_579370 = query.getOrDefault("fields")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "fields", valid_579370
  var valid_579371 = query.getOrDefault("access_token")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "access_token", valid_579371
  var valid_579372 = query.getOrDefault("upload_protocol")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "upload_protocol", valid_579372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579373: Call_DlpOrganizationsStoredInfoTypesList_579355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_579373.validator(path, query, header, formData, body)
  let scheme = call_579373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579373.url(scheme.get, call_579373.host, call_579373.base,
                         call_579373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579373, url, valid)

proc call*(call_579374: Call_DlpOrganizationsStoredInfoTypesList_579355;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsStoredInfoTypesList
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579375 = newJObject()
  var query_579376 = newJObject()
  add(query_579376, "key", newJString(key))
  add(query_579376, "prettyPrint", newJBool(prettyPrint))
  add(query_579376, "oauth_token", newJString(oauthToken))
  add(query_579376, "$.xgafv", newJString(Xgafv))
  add(query_579376, "pageSize", newJInt(pageSize))
  add(query_579376, "alt", newJString(alt))
  add(query_579376, "uploadType", newJString(uploadType))
  add(query_579376, "quotaUser", newJString(quotaUser))
  add(query_579376, "orderBy", newJString(orderBy))
  add(query_579376, "pageToken", newJString(pageToken))
  add(query_579376, "callback", newJString(callback))
  add(path_579375, "parent", newJString(parent))
  add(query_579376, "fields", newJString(fields))
  add(query_579376, "access_token", newJString(accessToken))
  add(query_579376, "upload_protocol", newJString(uploadProtocol))
  result = call_579374.call(path_579375, query_579376, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesList* = Call_DlpOrganizationsStoredInfoTypesList_579355(
    name: "dlpOrganizationsStoredInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesList_579356, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesList_579357, schemes: {Scheme.Https})
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
