
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Movies Partner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Gets the delivery status of titles for Google Play Movies Partners.
## 
## https://developers.google.com/playmoviespartner/
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
  gcpServiceName = "playmoviespartner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlaymoviespartnerAccountsAvailsList_578610 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsAvailsList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578738 = path.getOrDefault("accountId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "accountId", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   altId: JString
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: JString
  ##           : JSONP
  ##   title: JString
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
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
  var valid_578753 = query.getOrDefault("pp")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "pp", valid_578753
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("bearer_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "bearer_token", valid_578757
  var valid_578758 = query.getOrDefault("altIds")
  valid_578758 = validateParameter(valid_578758, JArray, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "altIds", valid_578758
  var valid_578759 = query.getOrDefault("pageSize")
  valid_578759 = validateParameter(valid_578759, JInt, required = false, default = nil)
  if valid_578759 != nil:
    section.add "pageSize", valid_578759
  var valid_578760 = query.getOrDefault("uploadType")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "uploadType", valid_578760
  var valid_578761 = query.getOrDefault("alt")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = newJString("json"))
  if valid_578761 != nil:
    section.add "alt", valid_578761
  var valid_578762 = query.getOrDefault("quotaUser")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "quotaUser", valid_578762
  var valid_578763 = query.getOrDefault("videoIds")
  valid_578763 = validateParameter(valid_578763, JArray, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "videoIds", valid_578763
  var valid_578764 = query.getOrDefault("pageToken")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "pageToken", valid_578764
  var valid_578765 = query.getOrDefault("altId")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "altId", valid_578765
  var valid_578766 = query.getOrDefault("pphNames")
  valid_578766 = validateParameter(valid_578766, JArray, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "pphNames", valid_578766
  var valid_578767 = query.getOrDefault("callback")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "callback", valid_578767
  var valid_578768 = query.getOrDefault("title")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "title", valid_578768
  var valid_578769 = query.getOrDefault("studioNames")
  valid_578769 = validateParameter(valid_578769, JArray, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "studioNames", valid_578769
  var valid_578770 = query.getOrDefault("territories")
  valid_578770 = validateParameter(valid_578770, JArray, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "territories", valid_578770
  var valid_578771 = query.getOrDefault("fields")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "fields", valid_578771
  var valid_578772 = query.getOrDefault("access_token")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "access_token", valid_578772
  var valid_578773 = query.getOrDefault("upload_protocol")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "upload_protocol", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_PlaymoviespartnerAccountsAvailsList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_PlaymoviespartnerAccountsAvailsList_578610;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          altIds: JsonNode = nil; pageSize: int = 0; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; videoIds: JsonNode = nil;
          pageToken: string = ""; altId: string = ""; pphNames: JsonNode = nil;
          callback: string = ""; title: string = ""; studioNames: JsonNode = nil;
          territories: JsonNode = nil; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsList
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   altId: string
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: string
  ##           : JSONP
  ##   title: string
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "pp", newJBool(pp))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "$.xgafv", newJString(Xgafv))
  add(query_578870, "bearer_token", newJString(bearerToken))
  if altIds != nil:
    query_578870.add "altIds", altIds
  add(query_578870, "pageSize", newJInt(pageSize))
  add(query_578870, "uploadType", newJString(uploadType))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "quotaUser", newJString(quotaUser))
  if videoIds != nil:
    query_578870.add "videoIds", videoIds
  add(query_578870, "pageToken", newJString(pageToken))
  add(query_578870, "altId", newJString(altId))
  if pphNames != nil:
    query_578870.add "pphNames", pphNames
  add(query_578870, "callback", newJString(callback))
  add(query_578870, "title", newJString(title))
  add(path_578868, "accountId", newJString(accountId))
  if studioNames != nil:
    query_578870.add "studioNames", studioNames
  if territories != nil:
    query_578870.add "territories", territories
  add(query_578870, "fields", newJString(fields))
  add(query_578870, "access_token", newJString(accessToken))
  add(query_578870, "upload_protocol", newJString(uploadProtocol))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var playmoviespartnerAccountsAvailsList* = Call_PlaymoviespartnerAccountsAvailsList_578610(
    name: "playmoviespartnerAccountsAvailsList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails",
    validator: validate_PlaymoviespartnerAccountsAvailsList_578611, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsList_578612, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsAvailsGet_578909 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsAvailsGet_578911(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "availId" in path, "`availId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails/"),
               (kind: VariableSegment, value: "availId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsGet_578910(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Avail given its avail group id and avail id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: JString (required)
  ##          : REQUIRED. Avail ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578912 = path.getOrDefault("accountId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "accountId", valid_578912
  var valid_578913 = path.getOrDefault("availId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "availId", valid_578913
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("pp")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "pp", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  var valid_578918 = query.getOrDefault("$.xgafv")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("1"))
  if valid_578918 != nil:
    section.add "$.xgafv", valid_578918
  var valid_578919 = query.getOrDefault("bearer_token")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "bearer_token", valid_578919
  var valid_578920 = query.getOrDefault("uploadType")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "uploadType", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("quotaUser")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "quotaUser", valid_578922
  var valid_578923 = query.getOrDefault("callback")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "callback", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
  var valid_578925 = query.getOrDefault("access_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "access_token", valid_578925
  var valid_578926 = query.getOrDefault("upload_protocol")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "upload_protocol", valid_578926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578927: Call_PlaymoviespartnerAccountsAvailsGet_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Avail given its avail group id and avail id.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_PlaymoviespartnerAccountsAvailsGet_578909;
          accountId: string; availId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsGet
  ## Get an Avail given its avail group id and avail id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: string (required)
  ##          : REQUIRED. Avail ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578929 = newJObject()
  var query_578930 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "pp", newJBool(pp))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "$.xgafv", newJString(Xgafv))
  add(query_578930, "bearer_token", newJString(bearerToken))
  add(query_578930, "uploadType", newJString(uploadType))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(query_578930, "callback", newJString(callback))
  add(path_578929, "accountId", newJString(accountId))
  add(path_578929, "availId", newJString(availId))
  add(query_578930, "fields", newJString(fields))
  add(query_578930, "access_token", newJString(accessToken))
  add(query_578930, "upload_protocol", newJString(uploadProtocol))
  result = call_578928.call(path_578929, query_578930, nil, nil, nil)

var playmoviespartnerAccountsAvailsGet* = Call_PlaymoviespartnerAccountsAvailsGet_578909(
    name: "playmoviespartnerAccountsAvailsGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails/{availId}",
    validator: validate_PlaymoviespartnerAccountsAvailsGet_578910, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsGet_578911, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersList_578931 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsOrdersList_578933(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersList_578932(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578934 = path.getOrDefault("accountId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "accountId", valid_578934
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   customId: JString
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   name: JString
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: JString
  ##           : JSONP
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("pp")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "pp", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("customId")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "customId", valid_578939
  var valid_578940 = query.getOrDefault("name")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "name", valid_578940
  var valid_578941 = query.getOrDefault("$.xgafv")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("1"))
  if valid_578941 != nil:
    section.add "$.xgafv", valid_578941
  var valid_578942 = query.getOrDefault("bearer_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "bearer_token", valid_578942
  var valid_578943 = query.getOrDefault("pageSize")
  valid_578943 = validateParameter(valid_578943, JInt, required = false, default = nil)
  if valid_578943 != nil:
    section.add "pageSize", valid_578943
  var valid_578944 = query.getOrDefault("uploadType")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "uploadType", valid_578944
  var valid_578945 = query.getOrDefault("alt")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("json"))
  if valid_578945 != nil:
    section.add "alt", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("videoIds")
  valid_578947 = validateParameter(valid_578947, JArray, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "videoIds", valid_578947
  var valid_578948 = query.getOrDefault("pageToken")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "pageToken", valid_578948
  var valid_578949 = query.getOrDefault("pphNames")
  valid_578949 = validateParameter(valid_578949, JArray, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "pphNames", valid_578949
  var valid_578950 = query.getOrDefault("callback")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "callback", valid_578950
  var valid_578951 = query.getOrDefault("status")
  valid_578951 = validateParameter(valid_578951, JArray, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "status", valid_578951
  var valid_578952 = query.getOrDefault("studioNames")
  valid_578952 = validateParameter(valid_578952, JArray, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "studioNames", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_PlaymoviespartnerAccountsOrdersList_578931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_PlaymoviespartnerAccountsOrdersList_578931;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; customId: string = ""; name: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; pageSize: int = 0;
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          videoIds: JsonNode = nil; pageToken: string = ""; pphNames: JsonNode = nil;
          callback: string = ""; status: JsonNode = nil; studioNames: JsonNode = nil;
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersList
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customId: string
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   name: string
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "pp", newJBool(pp))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "customId", newJString(customId))
  add(query_578959, "name", newJString(name))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "bearer_token", newJString(bearerToken))
  add(query_578959, "pageSize", newJInt(pageSize))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "quotaUser", newJString(quotaUser))
  if videoIds != nil:
    query_578959.add "videoIds", videoIds
  add(query_578959, "pageToken", newJString(pageToken))
  if pphNames != nil:
    query_578959.add "pphNames", pphNames
  add(query_578959, "callback", newJString(callback))
  add(path_578958, "accountId", newJString(accountId))
  if status != nil:
    query_578959.add "status", status
  if studioNames != nil:
    query_578959.add "studioNames", studioNames
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var playmoviespartnerAccountsOrdersList* = Call_PlaymoviespartnerAccountsOrdersList_578931(
    name: "playmoviespartnerAccountsOrdersList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders",
    validator: validate_PlaymoviespartnerAccountsOrdersList_578932, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersList_578933, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersGet_578960 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsOrdersGet_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersGet_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   orderId: JString (required)
  ##          : REQUIRED. Order ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578963 = path.getOrDefault("accountId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "accountId", valid_578963
  var valid_578964 = path.getOrDefault("orderId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "orderId", valid_578964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("pp")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "pp", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("$.xgafv")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("1"))
  if valid_578969 != nil:
    section.add "$.xgafv", valid_578969
  var valid_578970 = query.getOrDefault("bearer_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "bearer_token", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("callback")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "callback", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  var valid_578976 = query.getOrDefault("access_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "access_token", valid_578976
  var valid_578977 = query.getOrDefault("upload_protocol")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "upload_protocol", valid_578977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578978: Call_PlaymoviespartnerAccountsOrdersGet_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_PlaymoviespartnerAccountsOrdersGet_578960;
          accountId: string; orderId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersGet
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   orderId: string (required)
  ##          : REQUIRED. Order ID.
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "pp", newJBool(pp))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(query_578981, "$.xgafv", newJString(Xgafv))
  add(query_578981, "bearer_token", newJString(bearerToken))
  add(query_578981, "uploadType", newJString(uploadType))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(query_578981, "callback", newJString(callback))
  add(path_578980, "accountId", newJString(accountId))
  add(query_578981, "fields", newJString(fields))
  add(query_578981, "access_token", newJString(accessToken))
  add(query_578981, "upload_protocol", newJString(uploadProtocol))
  add(path_578980, "orderId", newJString(orderId))
  result = call_578979.call(path_578980, query_578981, nil, nil, nil)

var playmoviespartnerAccountsOrdersGet* = Call_PlaymoviespartnerAccountsOrdersGet_578960(
    name: "playmoviespartnerAccountsOrdersGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders/{orderId}",
    validator: validate_PlaymoviespartnerAccountsOrdersGet_578961, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersGet_578962, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosList_578982 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsStoreInfosList_578984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosList_578983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578985 = path.getOrDefault("accountId")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "accountId", valid_578985
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: JString
  ##           : JSONP
  ##   videoId: JString
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  section = newJObject()
  var valid_578986 = query.getOrDefault("key")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "key", valid_578986
  var valid_578987 = query.getOrDefault("pp")
  valid_578987 = validateParameter(valid_578987, JBool, required = false,
                                 default = newJBool(true))
  if valid_578987 != nil:
    section.add "pp", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("name")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "name", valid_578990
  var valid_578991 = query.getOrDefault("$.xgafv")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("1"))
  if valid_578991 != nil:
    section.add "$.xgafv", valid_578991
  var valid_578992 = query.getOrDefault("bearer_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "bearer_token", valid_578992
  var valid_578993 = query.getOrDefault("pageSize")
  valid_578993 = validateParameter(valid_578993, JInt, required = false, default = nil)
  if valid_578993 != nil:
    section.add "pageSize", valid_578993
  var valid_578994 = query.getOrDefault("seasonIds")
  valid_578994 = validateParameter(valid_578994, JArray, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "seasonIds", valid_578994
  var valid_578995 = query.getOrDefault("uploadType")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "uploadType", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("videoIds")
  valid_578998 = validateParameter(valid_578998, JArray, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "videoIds", valid_578998
  var valid_578999 = query.getOrDefault("pageToken")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "pageToken", valid_578999
  var valid_579000 = query.getOrDefault("mids")
  valid_579000 = validateParameter(valid_579000, JArray, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "mids", valid_579000
  var valid_579001 = query.getOrDefault("pphNames")
  valid_579001 = validateParameter(valid_579001, JArray, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "pphNames", valid_579001
  var valid_579002 = query.getOrDefault("callback")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "callback", valid_579002
  var valid_579003 = query.getOrDefault("videoId")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "videoId", valid_579003
  var valid_579004 = query.getOrDefault("studioNames")
  valid_579004 = validateParameter(valid_579004, JArray, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "studioNames", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("access_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "access_token", valid_579006
  var valid_579007 = query.getOrDefault("upload_protocol")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "upload_protocol", valid_579007
  var valid_579008 = query.getOrDefault("countries")
  valid_579008 = validateParameter(valid_579008, JArray, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "countries", valid_579008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579009: Call_PlaymoviespartnerAccountsStoreInfosList_578982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_PlaymoviespartnerAccountsStoreInfosList_578982;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; pageSize: int = 0; seasonIds: JsonNode = nil;
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          videoIds: JsonNode = nil; pageToken: string = ""; mids: JsonNode = nil;
          pphNames: JsonNode = nil; callback: string = ""; videoId: string = "";
          studioNames: JsonNode = nil; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; countries: JsonNode = nil): Recallable =
  ## playmoviespartnerAccountsStoreInfosList
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   callback: string
  ##           : JSONP
  ##   videoId: string
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "pp", newJBool(pp))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "name", newJString(name))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "bearer_token", newJString(bearerToken))
  add(query_579012, "pageSize", newJInt(pageSize))
  if seasonIds != nil:
    query_579012.add "seasonIds", seasonIds
  add(query_579012, "uploadType", newJString(uploadType))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "quotaUser", newJString(quotaUser))
  if videoIds != nil:
    query_579012.add "videoIds", videoIds
  add(query_579012, "pageToken", newJString(pageToken))
  if mids != nil:
    query_579012.add "mids", mids
  if pphNames != nil:
    query_579012.add "pphNames", pphNames
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "videoId", newJString(videoId))
  add(path_579011, "accountId", newJString(accountId))
  if studioNames != nil:
    query_579012.add "studioNames", studioNames
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  if countries != nil:
    query_579012.add "countries", countries
  result = call_579010.call(path_579011, query_579012, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosList* = Call_PlaymoviespartnerAccountsStoreInfosList_578982(
    name: "playmoviespartnerAccountsStoreInfosList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos",
    validator: validate_PlaymoviespartnerAccountsStoreInfosList_578983, base: "/",
    url: url_PlaymoviespartnerAccountsStoreInfosList_578984,
    schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosCountryGet_579013 = ref object of OpenApiRestCall_578339
proc url_PlaymoviespartnerAccountsStoreInfosCountryGet_579015(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "videoId" in path, "`videoId` is a required path parameter"
  assert "country" in path, "`country` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos/"),
               (kind: VariableSegment, value: "videoId"),
               (kind: ConstantSegment, value: "/country/"),
               (kind: VariableSegment, value: "country")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosCountryGet_579014(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   videoId: JString (required)
  ##          : REQUIRED. Video ID.
  ##   country: JString (required)
  ##          : REQUIRED. Edit country.
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `videoId` field"
  var valid_579016 = path.getOrDefault("videoId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "videoId", valid_579016
  var valid_579017 = path.getOrDefault("country")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "country", valid_579017
  var valid_579018 = path.getOrDefault("accountId")
  valid_579018 = validateParameter(valid_579018, JString, required = true,
                                 default = nil)
  if valid_579018 != nil:
    section.add "accountId", valid_579018
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579019 = query.getOrDefault("key")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "key", valid_579019
  var valid_579020 = query.getOrDefault("pp")
  valid_579020 = validateParameter(valid_579020, JBool, required = false,
                                 default = newJBool(true))
  if valid_579020 != nil:
    section.add "pp", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("$.xgafv")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("1"))
  if valid_579023 != nil:
    section.add "$.xgafv", valid_579023
  var valid_579024 = query.getOrDefault("bearer_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "bearer_token", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("quotaUser")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "quotaUser", valid_579027
  var valid_579028 = query.getOrDefault("callback")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "callback", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  var valid_579030 = query.getOrDefault("access_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "access_token", valid_579030
  var valid_579031 = query.getOrDefault("upload_protocol")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "upload_protocol", valid_579031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579032: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_579013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_579013;
          videoId: string; country: string; accountId: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## playmoviespartnerAccountsStoreInfosCountryGet
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   videoId: string (required)
  ##          : REQUIRED. Video ID.
  ##   country: string (required)
  ##          : REQUIRED. Edit country.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579034 = newJObject()
  var query_579035 = newJObject()
  add(query_579035, "key", newJString(key))
  add(query_579035, "pp", newJBool(pp))
  add(query_579035, "prettyPrint", newJBool(prettyPrint))
  add(query_579035, "oauth_token", newJString(oauthToken))
  add(query_579035, "$.xgafv", newJString(Xgafv))
  add(query_579035, "bearer_token", newJString(bearerToken))
  add(query_579035, "uploadType", newJString(uploadType))
  add(query_579035, "alt", newJString(alt))
  add(query_579035, "quotaUser", newJString(quotaUser))
  add(path_579034, "videoId", newJString(videoId))
  add(path_579034, "country", newJString(country))
  add(query_579035, "callback", newJString(callback))
  add(path_579034, "accountId", newJString(accountId))
  add(query_579035, "fields", newJString(fields))
  add(query_579035, "access_token", newJString(accessToken))
  add(query_579035, "upload_protocol", newJString(uploadProtocol))
  result = call_579033.call(path_579034, query_579035, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosCountryGet* = Call_PlaymoviespartnerAccountsStoreInfosCountryGet_579013(
    name: "playmoviespartnerAccountsStoreInfosCountryGet",
    meth: HttpMethod.HttpGet, host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos/{videoId}/country/{country}",
    validator: validate_PlaymoviespartnerAccountsStoreInfosCountryGet_579014,
    base: "/", url: url_PlaymoviespartnerAccountsStoreInfosCountryGet_579015,
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
